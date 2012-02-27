(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;; CVODE INTERFACE ;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; this file provides a generic Lisp interface to CVODE.  Many of
;; the functions referred to in this file must be defined via a 
;; foreign-function interface (e.g., see cvode_ffi_clisp.lisp).
;; This particular collection of code should be independent from 
;; any particular Lisp implementation, such that only the
;; interface code will need to vary based on the runtime.
;;
;; style note: FFI functions use the '_' character for variable and 
;; function names for compatibility with inferior languages.  Lisp
;; functions will use '-' by default.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; define constants related to CVODE success/failure
;; these are taken from #define statements in cvode.h and may
;; need updating if a newer version of CVODE is used
(defconstant +cv_success+              0)
(defconstant +cv_tstop_return+         1)
(defconstant +cv_root_return+          2)

(defconstant +cv_warning+             99)

;; note: all error codes are less than 0.
(defconstant +cv_too_much_work+       -1)
(defconstant +cv_too_much_acc+        -2)
(defconstant +cv_err_failure+         -3)
(defconstant +cv_conv_failure+        -4)

(defconstant +cv_linit_fail+          -5)
(defconstant +cv_lsetup_fail+         -6)
(defconstant +cv_lsolve_fail+         -7)
(defconstant +cv_rhsfunc_fail+        -8)
(defconstant +cv_first_rhsfunc_err+   -9)
(defconstant +cv_reptd_rhsfunc_err+  -10)
(defconstant +cv_unrec_rhsfunc_err+  -11)
(defconstant +cv_rtfunc_fail+        -12)

(defconstant +cv_mem_fail+           -20)
(defconstant +cv_mem_null+           -21)
(defconstant +cv_ill_input+          -22)
(defconstant +cv_no_malloc+          -23)
(defconstant +cv_bad_k+              -24)
(defconstant +cv_bad_t+              -25)
(defconstant +cv_bad_dky+            -26)

;; constants related to success or failure in the 
;; cvode interface functions
(defconstant +cvi_success+             0)
(defconstant +cvi_failure+            -1)

(declaim (special *algebraic-variables* *exogenous-variables* *model-constants*)
	 (type (simple-array double-float *) 
	       *algebraic-variables* *exogenous-variables* *model-constants*))

;;;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-sim-error? 
;;;
;;; returns t when there was an error in cvode simulation.
;;; all cvode error codes are less than 0.
(declaim (inline cvode-sim-error?))

(defun cvode-sim-error? (x) (declare (fixnum x)) (< x 0))


;;;;;;;;;;;;;;;;;;;;;;;;;
;;; store_data_vector
;;; 
;;; stores the global variable state into a single vector.  the ordering
;;; is time, algebraic, system, and exogenous.  this order should always be
;;; the same as that returned  by get-variables-lists
;;;
;;; when track-all? is true, the values of exogenous and algebraic variables
;;; are retained.  otherwise only the system variables are returned.
(defun cvode-store-data-vector (sim-time &optional track-all?)
  (let ((lst) 
	(alg-vars (vector-to-list *algebraic-variables*))
	(exo-vars (vector-to-list *exogenous-variables*))
	(sys-vars (get-sysvar-values)))
    (when (and track-all? exo-vars) (setf lst (append exo-vars lst)))
    (when sys-vars (setf lst (append sys-vars lst)))
    (when (and track-all? alg-vars) (setf lst (append alg-vars lst)))
    (setf lst (cons sim-time lst))
    (apply #'vector lst)))


;;;;;;;;;;;;;;;;;;;;;;;
;;; store_sa_matrix
;;; 
;;; when normalize is true, the sensitivity coefficient is
;;; multiplied by the parameter to produce a modified coefficient
;;; that takes the order of magnitude into account.
(defun store-sa-matrix (normalize)
  (let ((mtx (make-array (list (get_param_n) (get_sysvar_n)))))
    (dotimes (p (get_param_n) mtx)
      (dotimes (v (get_sysvar_n))
	(setf (aref mtx p v) 
	      (if normalize 
		  (* (if (= (get_param_val p) 0d0) 1d0 (get_param_val p)) (get_sensitivity p v))
		  (get_sensitivity p v)))))))


;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-sysvar-values
;;;
;;; returns the current values of the system variables in an ordered
;;; list
;;;
(defun get-sysvar-values ()
  (let ((lst))
    (do ((i (- (get_sysvar_n) 1) (- i 1)))
	((< i 0) lst)
      (push (get_sysvar_val i) lst))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-initial-data-values
;;;
;;; this function returns the initial data values for all system
;;; variables in the order that the variables appear in the
;;; array returned by getv-system-variables.
;;;
;;; ASSUME: case doesn't matter for column names in the data file.
;;;         this assumption is carried over from data.lisp and would
;;;         require a minor change in that file to remove it.  
;;;
;;;         Also assumes that no initial values are missing in the
;;;         data set.  Once a policy for missing values is
;;;         established, we could update this function to reflect it.
(defun cvode-initial-data-values (data)
  (mapcar #'(lambda (x)
	      (cond  ((variable?-initial-value (cdr x))
		      (variable?-initial-value (cdr x)) )
		     ((and data (variable?-data-name (cdr x)))
		      (coerce (datum-value (datum data 0) 
					   (intern (string-upcase (variable?-data-name (cdr x))))
					   data) 'double-float))
;; swapped the order of this with the option above to 
;; give priority to user-specified initial values over data specified values
;; XXX: *THIS IS TEMPORARY UNTIL WE FIX AN INTERFACE*
;		     ((variable?-initial-value (cdr x))
;		      (coerce (variable?-initial-value (cdr x)) 'double-float))
		    (t
		     0d0)))
	  (vector-to-list (getv-system-variables))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-variable-names
;;;
;;; returns a list of the model's variable names represented as
;;; strings.  if there's a data file and the variable has a data name,
;;; then the data name is used.  otherwise, variables are turned into
;;; strings as follows.
;;;
;;; container-name_variable-name
;;; ex/ entity1.variable1 = entity1_variable1
;;;
;;; XXX: process level variables are not supported yet
(defun get-variable-names (all-vars?)
  (cons 'time 
	(mapcar #'(lambda (x) 
		    (read-from-string 
		     (if (variable?-data-name (cdr x))
			 (variable?-data-name (cdr x))
		       (format nil "~A_~A" 
			       (entity-name (car x)) 
			       (print-variable? (cdr x) nil)))))
		(if all-vars? 
		    (apply #'nconc (get-variable-lists))
		  (vector-to-list (getv-system-variables))))))


;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-copy-constants
;;;
;;; CVODES will need to maintain a local store of the model constants
;;; when it performs sensitivity analysis.  this function copies the
;;; initial values of those constants over to the C side of the
;;; program.
;;;
;;; This function should be called after mem_alloc and before fill_in.
;;; You should be able to call this function even if you are not
;;; performing sensitivity analysis, as long as the init_dims argument
;;; specifying the number of parameters was less than or equal to the
;;; total number of model parameters.
(defun cvode-copy-constants ()
  (dotimes (i (get_param_n))
    (set_param_val i (aref *model-constants* i))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-prepare-model
;;;
;;; performs the basic initialization functions for running CVODE. if
;;; sa is true, then the program is prepared for sensitivity analysis.
(defun cvode-prepare-model (model &optional (sa nil))
  ;; create the model for simulation
  (let ((model-code 
	 ;; 
	 (make-cvode-model model (build-equations model) sa)))
    (eval model-code)
    (compile 'ms_model)
    (compile 'ms_model_no_diffeq)

    ;; since we're only simulating, there's no reason to pass parameters
    ;; around for SA.
    (init_dims (length (getv-system-variables))
	       (if sa (length (getv-constants)) 0)
	       #+clisp #'ms_model
	       #+cmu (alien:callback ms_model)
	       #+allegro (register-foreign-callable 'ms_model)
	       #+sbcl (callback:callback 'ms_model) ; RAB - this is a STUB!
	       )
    (mem_alloc)))


;;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-data-init
;;;
;;; reinitializes CVODE to the initial conditions in the specified
;;; data file.  should be extended to handle initial conditions passed
;;; in from the calling code (e.g., a parameter estimation routine).
(defun cvode-data-init (d)
  ;; match the initial conditions with their values in the data file
  ;; or the current defaults
  (let ((init-val-list (cvode-initial-data-values d)) 
	(init-val-array))
    (setf init-val-array (make-array (length init-val-list)
				     :element-type 'double-float
				     :initial-contents init-val-list))
    (init_cvode #+cmu (sys:vector-sap init-val-array)
		#-cmu init-val-array
		(coerce (datum-time d 0) 'double-float))))


;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-clean-up
;;;
;;; makes sure all the state of the program erturns to a stable
;;; condition after it's through with the current model.
(defun cvode-clean-up ()
  (mem_free))


;;;;;;;;;;;;;;;;;;;;;;;
;;; combined-sim-cvode 
;;;
;;; runs CVODE step-by-step and stores the results of the simulation.
;;;
;;; if a data file is supplied, then the file determines the start and
;;; end times, otherwise the user determines them.  
;;;
;;; a step size is required unless a data file is provided. if a step
;;; size is provided, it will override any step information in the
;;; data file otherwise the output will be synchronized with the data
;;; file.
;;;
;;; returns the simulation results followed by the CVODE return code.
;;; a failed simulation will return the results up until the error.
;;;
;;; when sa? is true, sensitivity information is returned
;;; when track-all? is true, all variable information is stored
;;;    otherwise, only the system variables are kept.
(defun combined-sim-cvode (data &key (start-time -1d0) (end-time -1d0) (step-size -1d0) (sa? nil) (track-all? nil))
  (declare (double-float start-time end-time step-size))
  "Simulate the current model with CVODE"
  (let ((ret-code)
	(var-names)                     ; the stored names of variables
	(data-lst)                      ; list of variable-value vectors
	(sim-index 0)
	(end-index)
	(sim-time #+sbcl 0d0)           ; w/o explicitly setting sim-time, 
					; the declare of type double-float fails
	(sa-results))
    (declare (double-float sim-time))
    (setf var-names (get-variable-names track-all?))

    ;; if data exist, start and end times are pulled from the data, but the
    ;; sample time may be adjusted by the user
    ;; otherwise, the user supplies the start and end times
    (if data
	(progn 
	  (setf sim-time (coerce (datum-time data sim-index) 'double-float))
	  (setf end-index (- (array-dimension (data-values data) 0) 1))
	  (setf end-time (coerce (datum-time data end-index) 'double-float)))
      (setf sim-time start-time))
    
    ;; prime the exogenous/algebraic variables
    (ms_model_no_diffeq sim-time)
    (push (cvode-store-data-vector sim-time track-all?) data-lst)
    (when sa? (push (store-sa-matrix t) sa-results))

    ;; we don't simulate the first point
    (if (> step-size 0)
	;; user-supplied step size
	(incf sim-time step-size)
	;; data inferred steps
	(setf sim-time (coerce (datum-time data (incf sim-index)) 'double-float)))

    ;; see cvode-store-data-vector for variable ordering
    (while (>= end-time sim-time)

      ;; simulate each step and store the results
      (setf ret-code 
	    (handler-case (sim_model_cvode sim-time)
			  ((or 
			    floating-point-overflow
			    ;#+cmu extensions:floating-point-invalid
			    ;#+allegro floating-point-invalid
			    floating-point-underflow) () +cvi_failure+)))

	      
      (when (cvode-sim-error? ret-code) ; all CVODE failure codes are negative
	(return-from combined-sim-cvode 
	  (list (when data-lst 
		  (make-data 
		   :names var-names
		   :values (apply #'vector (nreverse data-lst))))
		ret-code
		(when sa? (nreverse sa-results)))))
      ;; synchronize the algebraic/exogenous variables if necessary
      (when track-all?
	(ms_model_no_diffeq sim-time))
      (push (cvode-store-data-vector sim-time track-all?) data-lst)
      (when sa? (push (store-sa-matrix t) sa-results))

      ;; update the time
      (if (> step-size 0)
	  ;; user-supplied step size
	  (incf sim-time step-size)
	(progn
	  ;; data inferred steps
	  (incf sim-index)
	  (setf sim-time 
		(if (> sim-index end-index) 
		    (+ end-time 1)
		    (coerce (datum-time data sim-index) 'double-float))))))
    
    (list (make-data 
	   :names var-names
	   :values (apply #'vector (nreverse data-lst))
	   :id-name 'time)
	  ret-code
	  (when sa? (nreverse sa-results)))))

;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-simulate
;;;
;;; use this function to simulate a model that's not associated with
;;; any data file.  all the storage for the model is destroyed when
;;; this function exits, so use this for one-shot simulation.
;;;
;;; if sa? is true, then CVODE performs sensitivity analysis and the
;;; resulting information is returned along with the simulated
;;; values..
(defun cvode-simulate (model start-time end-time step-size sa?)
;  (declare (type (double-float start-time end-time step-size)))
  (let ((ret) (init-val-array) (init-val-list))
    (when model
      (cvode-prepare-model model sa?)
      (when sa? (cvode-copy-constants))
      ;; always start at the first row in the data file, and set SA
      (setf init-val-list (cvode-initial-data-values nil))
      (setf init-val-array (make-array (length init-val-list)
				       :element-type 'double-float
				       :initial-contents init-val-list))
      (fill_in start-time 
	       #+cmu (sys:vector-sap init-val-array)
	       #-cmu init-val-array
	       (if sa? 1 0))
      ;; match the initial conditions with their prespecified values
      (init_cvode 
       #+cmu (sys:vector-sap init-val-array)
       #-cmu init-val-array
       start-time)
      (setf ret (combined-sim-cvode nil 
					 :start-time start-time 
					 :end-time end-time 
					 :step-size step-size 
					 :sa? sa?
					 :track-all? t))
      (cvode-clean-up))
    ret))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cvode-simulate-data
;;;
;;; use this function to simulate the model over a list of data sets.
;;; all the storage for the model is destroyed when this function
;;; exits, so use this solely for one-shot simulation.  if sa? is
;;; true, this function also returns the results of a sensitivity
;;; analysis over the parameters.  when performing sensitivity
;;; analysis, the sensitivity of the model to the parameters is
;;; considered and reported for each data set independently.

;;; not referenced in SCIPM. Not thread safe because of *current-data-set* and *data-sets*
#-THREADED-SCIPM
(defun cvode-simulate-data (model datasets sa?)
  (let ((ret) (init-val-array) (init-val-list) (tmp))
    (when (and model datasets)
      (setf *data-sets* datasets)
      (cvode-prepare-model model sa?)
      (when sa? (cvode-copy-constants))
      (setf init-val-list (cvode-initial-data-values nil))
      (setf init-val-array (make-array (length init-val-list)
				       :element-type 'double-float
				       :initial-contents init-val-list))
      ;; always start at the first row in the data file, and turn off SA
      (fill_in (coerce (datum-time (car datasets) 0) 'double-float) 
	       #+cmu (sys:vector-sap init-val-array)
	       #-cmu init-val-array
	       (if sa? 1 0))
      (dolist (d datasets)
	(setf *current-data-set* d)
	;; match the initial conditions with their values in the data file
	(cvode-data-init d)
	(setf tmp (combined-sim-cvode d :sa? sa? :track-all? t))
	(push 
	 (if sa?
	     (list (first tmp) (third tmp))
	   (first tmp))
	 ret))
      (cvode-clean-up))
    (nreverse ret)))


;;;;;;;;;;;;;;;;; END CVODE ;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;; The following code is for testing purposes and may not work.

;;; 
;;; takes the results of senstivity analysis and stores them to a text file
;;;
(defun temp-sa-to-text (lst &optional (stream t))
  (let ((tidx 0))
    (dolist (tval lst)
      (dotimes (pidx (array-dimension tval 0))
	(dotimes (vidx (array-dimension tval 1))
	  (format stream "~A,~A,~A,~A~%" 
		  ;; stuart wants the indices to start at 1
		  (+ 1 tidx) (+ 1 pidx) (+ 1 vidx) 
		  (coerce (aref tval pidx vidx) 'single-float))))
      (incf tidx))))


(defun temp-sim-to-text (data &optional (stream t))
  (let ((mtx (data-values data))
	(nvals (length (data-names data))))
    (dolist (name (data-names data))
      (format stream "~A " name))
    (dotimes (row-idx (array-dimension mtx 0))
      (format stream "~%")
      (dotimes (idx nvals)
	(format stream "~A " (coerce (aref (datum data row-idx) idx) 'single-float))))))
      
; (With-open-file (str (make-pathname :name "psa.txt") :direction :output) (temp-sa-to-text (third x) str))
; (With-open-file (str (make-pathname :name "psa-data.txt") :direction :output) (temp-sim-to-text (first x) str))

;; pieced together for testing purposes, should be replaced with a
;; system generated function that passes the appropriate parameters.

;(defun test_cvode ()
;  (cvode-simulate-data-sa ross-sea-1 (read-data-from-file "rs-yr1-sa.data")))

;(defun test_cvode ()
;  (cvode-simulate-data ross-sea-1 (list (read-data-from-file "rs-yr1-sa.data"))))

;(defun test_cvode ()
;  (cvode-simulate-sa predprey 0d0 35d0 0.5d0))
