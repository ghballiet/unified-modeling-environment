(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;; MAKE CVODE MODEL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;; The functions in this file build the ms_model function that
;;;;; CVODE calls to evaluate a system of equations.  They also build
;;;;; a function called ms_model_no_diffeq that can be used to update
;;;;; the algebraic and exogenous variables after a point along the
;;;;; trajectory is simulated.
;;;;;
;;;;;
;;;;; Implementation notes:
;;;;;
;;;;; CVODE doesn't need to know about algebraic or exogenous
;;;;; variables, so we can represent those entirely in Lisp.  The
;;;;; system variables have to be transparent to CVODE.  In some cases
;;;;; the algebraic and exogenous variables in Lisp can be out of step
;;;;; with the differential variables.  The values will be updated
;;;;; during the next call to CVODE, but due to the nature of the
;;;;; simulation (algebraic and exogenous variables are updated first,
;;;;; then the values of the differential variables are calculated),
;;;;; they will always be out of step.  So, call ms_model_no_diffeq
;;;;; after the system has been simulated and before the predictions
;;;;; are squirreled away.
;;;;;
;;;;; For sensitivity analysis, CVODES must know about the parameters
;;;;; as well.
;;;;;
;;;;; ASSUME: all data sets have the same column format the time
;;;;;         column is named "time" for the in-memory data set
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#+allegro (use-package :ff)
#+cmu (use-package :alien)
#+cmu (use-package :c-call)

(declaim (special *algebraic-variables* *exogenous-variables*
		  *system-variables* *model-constants*)
	 (type (simple-array double-float *) *algebraic-variables* *exogenous-variables*
	       *system-variables* *model-constants*))

;;;;;;;;;;;;;;;;;;;;;;;;
;;; make-cvode-model
;;;
;;; this function returns a list that, when passed to eval, creates
;;; the MS_model function called by CVODE.  evaluating the list will
;;; also create the function MS_model_no_diffeq, which can be used to
;;; update the values of the algebraic and exogenous variables
;;; independent of an update to the system variables.
;;;
;;; this function requires a model and a list of conditions--equation
;;; pairings as returned by build-equations.  if CVODES should report
;;; on sensitivity analysis, then the optional parameter should be 't.
(defun make-cvode-model (model lst &optional sa?)
  (let ((ceqs  (combine-equations lst)))
    ;; initialize the variable information
    (build-var-structures model lst)
    ;; set up the storage for algebraic and exogenous variables
    (setf *algebraic-variables* (make-array (length (getv-algebraic-variables))
					    :element-type 'double-float
					    :initial-element 0d0)
	  *exogenous-variables* (make-array (length (getv-exogenous-variables)) 
					    :element-type 'double-float
					    :initial-element 0d0)
	  *system-variables* (make-array (length (getv-system-variables)) 
					 :element-type 'double-float
					 :initial-element 0d0))
    ;; for sensitivity analysis, we'll also need to store the
    ;; parameter values in C, otherwise, we'll keep them entirely in
    ;; Lisp because CVODES doesn't need to know about them.

    #+clisp (setf *model-constants* (apply #'vector (make-list 
						     (length (getv-constants))
						     :initial-element 0d0)))
    #-clisp (setf *model-constants* (make-array 
				     (length (getv-constants)) 
				     :element-type 'double-float))
    (fill-model-constants)
    ;; build the function for the model
    (cvode-make-MS-model ceqs sa?)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-make-MS-model
;;;
;;; this function builds the list that evaluates to the MS_model and
;;; MS_model_no_diffeq functions used for CVODE simulation.  it takes
;;; as input a list of condition--equation pairs.  the sa? parameter
;;; should be non-nil if sensitivity analysis should be performed.
;;;
;;; if sensitivity analysis is turned on, the parameters will be
;;; accessed through C data structures.  otherwise, their values will
;;; come from *model-constants* in Lisp.
;;;
;;; order:
;;;   * fill exogenous variable array
;;;   * fill Lisp system variable array
;;;   * evaluate algebraic equations
;;;   * evaluate differential equations
;;;
;;; note: algebraic values will be out of synch at the end of a
;;; simulation run and must be recalculated before they're believed.
;(defvar *model-counter* 0)

;; RAB - place holder function for one defined and compiled with each call to cvode-make-MS-model

(defun MS_model_no_diffeq (time)
  (declare (ignorable time))
  (error "MS_model_no_diffeq should have been re-defined in a call to cvode-make-MS-model"))

(defun cvode-make-MS-model (system sa?)
;  (setf *model-counter* 0)
  `(progn
     ;; we need to accomodate Allegro's method for defining callbacks.
     ,(append 
       #+clisp '(defun MS_model (time) 
		 (declare (optimize (speed 3) (safety 0))
		  (double-float time)))
       #+allegro '(defun-foreign-callable MS_model ((time :double)) 
		   (declare (optimize (speed 3) (safety 0))) )
					;(incf *model-counter*) )
       #+cmu '(def-callback MS_model (void (time c-call:double)) 
	       (declare (optimize (speed 3) (safety 0))) )
					;(incf *model-counter*) )
       #+sbcl '(callback:defcallback MS_model (void (time (* double))) ;; RAB - a STUB!!
		(declare (optimize (speed 3) (safety 0))) )
       (assign-exo-vars (getv-exogenous-variables) 'time)
       (cvode-assign-sys-vars)
       (cvode-generate-f-equations system sa? t))
     ,(append '(defun MS_model_no_diffeq (time) 
		 (declare (optimize (speed 3) (safety 0))
		  (double-float time)))
	      (assign-exo-vars (getv-exogenous-variables) 'time)
	      (cvode-assign-sys-vars)
	      (cvode-generate-f-equations system sa? nil))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-assign-sys-vars
;;;
;;; this function returns a list that defines code that stores the
;;; current values of the system variables in a Lisp vector.
;;;
;;; when clisp calls the function get_sysvar_val, it allocates 16
;;; bytes of memory in which it stores the return value.  each call to
;;; get_sysvar_val grabs 16 more bytes, which can add up to a
;;; substantial amount of memory (and GC calls) during simulation.
;;; so, we store the values of the system variables locally (i.e., in
;;; Lisp) to speed up access time and to avoid unnecessary garbage.
(defun cvode-assign-sys-vars ()
  (let ((syslst))
    (dotimes (i (length *system-variables*) syslst)
      (push `(setf (#+clisp svref #-clisp aref *system-variables* ,i) 
		   (get_sysvar_val ,i))
	    syslst))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-generate-f-equations
;;;
;;; this function generates the code for the differential and
;;; algebraic equations that goes into the MS_model function.  if
;;; sensitivity analysis is being performed, then sa? should be
;;; non-nil.  if diffeq? is nil, then only the algebraic equations are
;;; returned.
;;;
;;; as input, the function expects a system of condition--equation
;;; pairs as produced by build-equations
(defun cvode-generate-f-equations (system sa? diffeq?)
  (let ((alg-eqs (order-algebraic-equations (remove-if #'differential-equation-p system)))
	(diff-eqs (remove-if #'algebraic-equation-p system))
	(eqs))
    ;; first, take care of the differential equations if necessary
    (when diffeq?
      (dolist (e diff-eqs)
	(push `(set_sysvar_dotval
		,(car (gethash (diff-eq-variable e) (get-var-idx-map)))
					;(coerce 
		,(cvode-replace-vars-consts (diff-eq-rhs e) sa?)
					;'double-float)
		)
	      eqs)))
    ;; now process the algebraic equations
    (dolist (e alg-eqs)
      (push `(setf (#+clisp svref #-clisp aref *algebraic-variables*
			 ,(car (gethash (alg-eq-variable e) (get-var-idx-map))))
		   ,(cvode-replace-vars-consts (alg-eq-rhs e) sa?))
	    eqs))
    eqs))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-replace-vars-consts
;;;
;;; this function replaces the variables and constants in the given
;;; equation with accessors to their storage locations in memory.  if
;;; CVODES is used for sensitivity analysis ensure that sa? is
;;; non-nil.
(defun cvode-replace-vars-consts (eq sa?)
  (cond ((atom eq)
	 eq)
	((or (variable?-p (cdr eq))
	     (constant?-p (cdr eq)))
	 (let ((pos (gethash eq (get-var-idx-map))))
	   (cond ((eq (cdr pos) 'ALG)
		  `(the double-float 
		     (#+clisp svref #-clisp aref *algebraic-variables*
			      ,(car pos))))
		 ((eq (cdr pos) 'SYS)
		  `(the double-float 
		     (#+clisp svref #-clisp aref *system-variables*
			      ,(car pos))))
		 ((eq (cdr pos) 'EXO)
		  `(the double-float 
		     (#+clisp svref #-clisp aref *exogenous-variables*
			      ,(car pos))))
		 ((eq (cdr pos) 'CON)
		  (if sa?
		      `(the double-float (get_param_val ,(car pos)))
		      `(the double-float 
			 (#+clisp svref #-clisp aref *model-constants*
				  ,(car pos))))))))
	(t 
	 (cons (cvode-replace-vars-consts (car eq) sa?)
	       (cvode-replace-vars-consts (cdr eq) sa?)))))


;;;;;;;;;;;;;;;;;;;; END CREATE MODEL FOR CVODE ;;;;;;;;;;;;;;;;;;;;;





;;;;; NOTES
;; CVODE doesn't need to know about algebraic or exogenous variables,
;; so we can represent those entirely in Lisp.  The system variables
;; have to be transparent to CVODE.  CVODES must also know about the
;; parameters.
;;
;; ASSUME: all data sets have the same column format
;;         the time column is named "time" for the in-memory data set
