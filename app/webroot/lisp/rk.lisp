(in-package :scipm)

(defconstant +rk4-failure+ -1)

#+THREADED-SCIPM
(declaim
 (special *algebraic-variables* *exogenous-variables* *system-variables*
	  *model-constants*)
 (type (simple-array double-float *)
       *algebraic-variables* *exogenous-variables*
       *system-variables* *model-constants*))

;;;;;;;;;;;;;;;;;;;;;;;;
;;; rk4-sim-error? 
;;;
;;; returns t when there was an error in rk4 simulation.
;;; all rk4 error codes are less than 0.

(declaim (inline rk4-sim-error?))
(defun rk4-sim-error? (x) (< x 0))

;;;;;;;;;;;;;;;;;;;;;;;
;;; combined-sim-rk4 
;;;
;;; runs a fourth-order Runge--Kutta method step-by-step and stores
;;; the results of the simulation.
;;;
;;; if a data file is supplied, then the file determines the start and
;;; end times, otherwise the user determines them.  
;;;
;;; a step size is required unless a data file is provided. if a step
;;; size is provided, it will override any step information in the
;;; data file otherwise the output will be synchronized with the data
;;; file.
;;;
;;; returns the simulation results followed by the RK4 return code.
;;; a failed simulation will return the results up until the error.
;;;
;;; when sa? is true, sensitivity information is returned
;;; when track-all? is true, all variable information is stored
;;;    otherwise, only the system variables are kept.

;;; ---------
;; RAB - place holder function for one defined and compiled with each call to rk4-make-model
#-COMPILED-LAMBDA
(defun rk4_model (time y-arr dydt-arr)
  (declare (ignorable time y-arr dydt-arr)
	   (double-float time)
	   (type (simple-array double-float) y-arr dydt-arr))
  (error "RK4_MODEL should have been re-defined in a call to RK4-MAKE-MODEL"))

;; RAB - place holder function for one defined and compiled with each call to rk4-make-model
#-COMPILED-LAMBDA
(defun rk4_model_no_diffeq (time y-arr)
  (declare (ignorable time y-arr)
	   (double-float time)
	   (type (simple-array double-float) y-arr))
  (error "RK4_MODEL_NO_DIFFEQ should have been re-defined in a call to RK4-MAKE-MODEL"))

#-COMPILED-LAMBDA
(declaim (ftype (function (double-float 
			   (simple-array double-float)
			   (simple-array double-float))
			  double-float)
		rk4_model))
;;; ---------

(defun combined-sim-rk4 (data &key (start-time -1d0) (end-time -1d0) 
			 (step-size -1d0) (track-all? nil))
  (declare (type double-float start-time end-time step-size)
	   #+COMPILED-LAMBDA
	   (special rk4_model_no_diffeq_fnc))
  "Simulate the current model with a fourth-order Runge--Kutta implementation."
  (let ((ret-code 0)
	(var-names)		      ; the stored names of variables
	(data-lst)		      ; list of variable-value vectors
	(sim-index 0)
	(end-index)
	(sim-time 0d0)
	(prev-sim-time 0d0)
	(tmp-array (make-array (array-dimensions *system-variables*)
			       :element-type 'double-float)))
    (declare (type double-float sim-time prev-sim-time))
    (setf var-names (get-variable-names track-all?))

    ;; if data exist, start and end times are pulled from the data, but the
    ;; sample time may be adjusted by the user
    ;; otherwise, the user supplies the start and end times
    (if data
	(setf sim-time (coerce (datum-time data sim-index) 'double-float)
	      end-index (- (array-dimension (data-values data) 0) 1)
	      end-time (coerce (datum-time data end-index) 'double-float))
	(setf sim-time start-time))
    ;; prime the exogenous/algebraic variables
    #+COMPILED-LAMBDA
    (funcall rk4_model_no_diffeq_fnc sim-time *system-variables*)
    #-COMPILED-LAMBDA
    (rk4_model_no_diffeq sim-time *system-variables*)
    (push (rk4-store-data-vector sim-time track-all?) data-lst)
    (setf prev-sim-time sim-time)
    ;; we don't simulate the first point
    (if (> step-size 0d0)
	;; user-supplied step size
	(incf sim-time step-size)
	;; data inferred steps
	(setf sim-time (coerce (datum-time data (incf sim-index)) 'double-float)))

    (let #+THREADED-SCIPM 
      ((h2 0d0) (h6 0d0) (n 0) ytemp dydt k1 k2 k3)
      #-THREADED-SCIPM  ()
      #+THREADED-SCIPM 
      (declare (special h2 h6 n ytemp dydt k1 k2 k3))
      ;; see rk4-store-data-vector for variable ordering
      (while (>= end-time sim-time)
	;; simulate each step and store the results
	(dotimes (i (array-dimension *system-variables* 0))
	  (setf (aref tmp-array i) 
		(#+clisp svref #-clisp aref *system-variables* i)))
	(setf ret-code
	      (sim-model-rk4 sim-time tmp-array
			     (if (> step-size 0d0) step-size
				 (- sim-time prev-sim-time))))

	(when (rk4-sim-error? ret-code) ; all rk4 failure codes are negative
	  (return-from combined-sim-rk4
	    (list (when data-lst 
		    (make-data 
		     :names var-names
		     :values (apply #'vector (nreverse data-lst))))
		  ret-code)))
	;; synchronize the algebraic/exogenous variables if necessary
	(dotimes (i (array-dimension *system-variables* 0))
	  (setf (#+clisp svref #-clisp aref *system-variables* i)
		(aref tmp-array i)))
	(when track-all?
	  #+COMPILED-LAMBDA
	  (funcall rk4_model_no_diffeq_fnc sim-time *system-variables*)
	  #-COMPILED-LAMBDA
	  (rk4_model_no_diffeq sim-time *system-variables*))
	(push (rk4-store-data-vector sim-time track-all?) data-lst)

	;; update the time
	(if (> step-size 0d0)
	    ;; user-supplied step size
	    (incf sim-time step-size)
	    (progn
	      ;; data inferred steps
	      (incf sim-index)
	      (setf prev-sim-time sim-time)
	      (setf sim-time 
		    (if (> sim-index end-index) 
			(+ end-time 1)
			(coerce (datum-time data sim-index) 'double-float)))))))
    
    (list (make-data 
	   :names var-names
	   :values (apply #'vector (nreverse data-lst))
	   :id-name 'time)
	  ret-code)))


;;;;;;;;;;;;;;;;;;;;;
;;; sim-model-rk4 
;;;
;;; we based this function on the standard form of the fourth-order
;;; runge--kutta method of solving differential equations.  the
;;; mathematical formulation came from wikipedia.
#-THREADED-SCIPM 
(let ((h2 0d0) (h6 0d0) (n 0)
      (ytemp (make-array 0 :element-type 'double-float))
      (dydt (make-array 0 :element-type 'double-float))
      (k1 (make-array 0 :element-type 'double-float))
      (k2 (make-array 0 :element-type 'double-float))
      (k3 (make-array 0 :element-type 'double-float)))
  (declare (type double-float h2 h6)
	   (type fixnum n)
	   (type (simple-array double-float) ytemp dydt k1 k2 k3))
  (defun sim-model-rk4 (time y-arr h)
    (declare (optimize (speed 3))
	     (type double-float time h h2 h6)
	     (type fixnum n)
	     (type (simple-array double-float) y-arr)
	     #+COMPILED-LAMBDA
	     (special rk4_model_fnc))
    (or
     (handler-case 
	 (progn
	   (setf h2 (* 0.5d0 h)
		 h6 (* (/ 1d0 6d0) h)
		 n (array-dimension y-arr 0))
	   (when (or (null ytemp) (/= (array-dimension ytemp 0) n))
	     (setf ytemp (make-array n :element-type 'double-float)))
	   (when (or (null dydt) (/= (array-dimension dydt 0) n))
	     (setf dydt (make-array n :element-type 'double-float)))
	   (when (or (null k1) (/= (array-dimension k1 0) n))
	     (setf k1 (make-array n :element-type 'double-float)))
	   (when (or (null k2) (/= (array-dimension k2 0) n))
	     (setf k2 (make-array n :element-type 'double-float)))
	   (when (or (null k3) (/= (array-dimension k3 0) n))
	     (setf k3 (make-array n :element-type 'double-float)))
	   
	   ;; RK methods treat every point as an initial condition, so 
	   ;; we can leave dydt uninitialized
	   
	   ;; call 1
	   #-COMPILED-LAMBDA (rk4_model time y-arr dydt)
	   #+COMPILED-LAMBDA (funcall rk4_model_fnc time y-arr dydt)
	   
	   ;; store k1 values and generate the y values for call 2
	   (dotimes (i n)
	     (setf (aref k1 i) (aref dydt i)
		   (aref ytemp i) (+ (aref y-arr i) (* h2 (aref k1 i)))))
	   
	   ;; call 2
	   #-COMPILED-LAMBDA (rk4_model (+ time h2)  ytemp dydt)
	   #+COMPILED-LAMBDA (funcall rk4_model_fnc (+ time h2)  ytemp dydt)
	   
	   ;; store k2 values and generate the y values for call 3
	   (dotimes (i n)
	     (setf (aref k2 i) (aref dydt i))
	     (setf (aref ytemp i) (+ (aref y-arr i) (* h2 (aref k2 i)))))
	   
	   ;; call 3
	   #-COMPILED-LAMBDA (rk4_model (+ time h2) ytemp dydt)
	   #+COMPILED-LAMBDA (funcall rk4_model_fnc (+ time h2) ytemp dydt)
	   
	   ;; store the k3 values and generate the y values for call 4
	   (dotimes (i n)
	     (setf (aref k3 i) (aref dydt i))
	     (setf (aref ytemp i) (+ (aref y-arr i) (* h (aref k3 i)))))
	   
	   ;; call 4
	   ;; dydt holds the values for k4
	   #-COMPILED-LAMBDA (rk4_model (+ time h) ytemp dydt)
	   #+COMPILED-LAMBDA (funcall rk4_model_fnc (+ time h) ytemp dydt)
	     
	   ;; generate the final solution for y
	   (dotimes (i n)
	     (setf (aref y-arr i) 
		   (+ (aref y-arr i) 
		      (* h6 (+ (aref k1 i) 
			       (* 2d0 (aref k2 i))
			       (* 2d0 (aref k3 i))
			       (aref dydt i)))))
	     #+allegro (decode-float (aref y-arr i))
	     ))
       ((or floating-point-overflow 
	 #+allegro division-by-zero
					;#+allegro floating-point-invalid
	 #+allegro simple-error
	 floating-point-underflow) () +rk4-failure+))
     0)))

#+COMPILED-LAMBDA
(declaim (special rk4_model_fnc))
#+THREADED-SCIPM 
(declaim (special h2 h6 n ytemp dydt k1 k2 k3))
#+THREADED-SCIPM 
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defmacro ensure-sim-model-rk4-arrays (name-list)
    `(progn
       ,@(loop for name 
	    in name-list
	    collect `(when (or (not (boundp ',name))
			       (null ,name) 
			       (/= (array-dimension ,name 0) n))
		       (setf ,name (make-array n :element-type 'double-float)))))))
#+THREADED-SCIPM 
(defun sim-model-rk4 (time y-arr h)
  (declare (type double-float time h h2 h6)
	   (type fixnum n)
	   (type (simple-array double-float) y-arr)
	   #+DEBUG-PE-SIM
	   (special pe-sim-1 pe-sim-d pe-sim-2 pe-sim-cnt))
  (or
   (handler-case 
       (progn
	 (setf h2 (* 0.5d0 h)
	       h6 (* (/ 1d0 6d0) h)
	       n (array-dimension y-arr 0))
	 (ensure-sim-model-rk4-arrays (ytemp dydt k1 k2 k3))
	   
	 ;; RK methods treat every point as an initial condition, so 
	 ;; we can leave dydt uninitialized
	 
	 ;; call 1
	 (funcall rk4_model_fnc time y-arr dydt)
	 #+DEBUG-PE-SIM
	 (case (first pe-sim-cnt)
	   (1 (push :call1 pe-sim-1))
	   ('sim-model-717-rk4 (push :call1 pe-sim-d))
	   (2 (push :call1 pe-sim-2)))
	   
	 ;; store k1 values and generate the y values for call 2
	 (dotimes (i n)
	   (setf (aref k1 i) (aref dydt i)
		 (aref ytemp i) (+ (aref y-arr i) (* h2 (aref k1 i)))))
	 ;; call 2
	 (funcall rk4_model_fnc (+ time h2)  ytemp dydt)
	 #+DEBUG-PE-SIM
	 (case (first pe-sim-cnt)
	   (1 (push :call2 pe-sim-1))
	   ('sim-model-717-rk4 (push :call2 pe-sim-d))
	   (2 (push :call2 pe-sim-2)))
	   
	 ;; store k2 values and generate the y values for call 3
	 (dotimes (i n)
	   (setf (aref k2 i) (aref dydt i))
	   (setf (aref ytemp i) (+ (aref y-arr i) (* h2 (aref k2 i)))))
	 ;; call 3
	 (funcall rk4_model_fnc (+ time h2) ytemp dydt)
	 #+DEBUG-PE-SIM
	 (case (first pe-sim-cnt)
	   (1 (push :call3 pe-sim-1))
	   ('sim-model-717-rk4 (push :call3 pe-sim-d))
	   (2 (push :call3 pe-sim-2)))
	   
	 ;; store the k3 values and generate the y values for call 4
	 (dotimes (i n)
	   (setf (aref k3 i) (aref dydt i))
	   (setf (aref ytemp i) (+ (aref y-arr i) (* h (aref k3 i)))))
	 ;; call 4
	 ;; dydt holds the values for k4
	 (funcall rk4_model_fnc (+ time h) ytemp dydt)
	 #+DEBUG-PE-SIM
	 (case (first pe-sim-cnt)
	   (1 (push :call4 pe-sim-1))
	   ('sim-model-717-rk4 (push :call4 pe-sim-d))
	   (2 (push :call4 pe-sim-2)))
	 ;; generate the final solution for y
	 (dotimes (i n)
	   (setf (aref y-arr i) 
		 (+ (aref y-arr i) 
		    (* h6 (+ (aref k1 i) 
			     (* 2d0 (aref k2 i))
			     (* 2d0 (aref k3 i))
			     (aref dydt i)))))
	   #+allegro (decode-float (aref y-arr i))
	   ))
     ((or floating-point-overflow 
       #+allegro division-by-zero
					;#+allegro floating-point-invalid
       #+allegro simple-error
       floating-point-underflow) () +rk4-failure+))
   0))

;; rk_model should take the time, the previous x values, and the previous dx/dt values.
;; in rk4, x and dx/dt vary to produce the approximation.

;; i think that i can reuse a number of the functions that appeared to
;; be cvode specific.
(defun make-rk4-model  (model lst)
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
    (setf *model-constants* 
	  #+clisp (apply #'vector (make-list (length (getv-constants)) 
					     :initial-element 0d0))
	  #-clisp (make-array (length (getv-constants))
			      :element-type 'double-float
			      :initial-element 0d0))
	  
    (fill-model-constants)
    ;; build the function for the model
    (rk4-make-model ceqs)))


#+COMPILED-LAMBDA-FOR-DEBUGGING
(defun rk4-make-model (system)
  #+DEBUG-ODE (declare (special *debug-ode* *debug-non-ode*))
					;  (setf *model-counter* 0)
  #+DEBUG-ODE
  (setf *debug-ode* `(lambda (time y-arr dydt-arr) 
		       (declare	      ;(optimize (speed 3) (safety 0))
			(double-float time)
			(special *algebraic-variables* *exogenous-variables*
				 *system-variables* *model-constants*)
			#+DEBUG-PE-SIM
			(special pe-sim-1 pe-sim-2 pe-sim-d)
			;; (type (simple-array double-float *) y-arr dydt-arr
			;;     *algebraic-variables* *exogenous-variables*
			;;     *system-variables* *model-constants*)
			(ignorable time y-arr dydt-arr))
		       ;;       (incf *model-counter*)
		       #+DEBUG-PE-SIM
		       (case (first pe-sim-cnt)
			 (1 (push (list time (print-vector y-arr)
					(print-vector dydt-arr)) pe-sim-1))
			 ('sim-model-717-rk4 (push (list time (print-vector y-arr)
							 (print-vector dydt-arr))
						   pe-sim-d))
			 (2 (push (list time (print-vector y-arr)
					(print-vector dydt-arr)) pe-sim-2)))
		       ,@(loop for sexpr
			    in (assign-exo-vars (getv-exogenous-variables) 'time)
			    count 1 into counter
			    append (list 
				    #+DEBUG-PE-SIM
				    `(case (first pe-sim-cnt)
				       (1 (push ,(format nil "x-~A" counter) pe-sim-1))
				       ('sim-model-717-rk4 
					(push ,(format nil "x-~A" counter) pe-sim-d))
				       (2 (push ,(format nil "x-~A" counter) pe-sim-2)))
				    sexpr))
		       ,@(loop for sexpr
			    in (rk4-generate-f-equations system t)
			    count 1 into counter
			    append (list 
				    #+DEBUG-PE-SIM
				    `(case (first pe-sim-cnt)
				       (1 (push ,(format nil "f-~A" counter) pe-sim-1))
				       ('sim-model-717-rk4 
					(push ,(format nil "f-~A" counter) pe-sim-d))
				       (2 (push ,(format nil "f-~A" counter) pe-sim-2)))
					 sexpr)))
	*debug-non-ode* `(lambda (time y-arr) 
			   (declare   ;(optimize (speed 3) (safety 0))
			    (double-float time)
			    (special *algebraic-variables* *exogenous-variables*
				     *system-variables* *model-constants*)
			    ;; (type (simple-array double-float *) y-arr
			    ;;     *algebraic-variables* *exogenous-variables*
			    ;;     *system-variables* *model-constants*)
			    (ignorable time y-arr))
			   ,@(assign-exo-vars (getv-exogenous-variables) 'time)
			   ,@(rk4-generate-f-equations system nil)))
  (values (compile 
	   NIL
	   `(lambda (time y-arr dydt-arr)
	      (declare		      ;(optimize (speed 3) (safety 0))
	       (double-float time)
	       (special *algebraic-variables* *exogenous-variables*
			*system-variables* *model-constants*)
	       #+DEBUG-PE-SIM
	       (special pe-sim-1 pe-sim-2 pe-sim-d)
	       ;; (type (simple-array double-float *) y-arr dydt-arr
	       ;;     *algebraic-variables* *exogenous-variables*
	       ;;     *system-variables* *model-constants*)
	       (ignorable time y-arr dydt-arr))
	      ;;       (incf *model-counter*)
	      #+DEBUG-PE-SIM
	      (case (first pe-sim-cnt)
		(1 (push (list time (print-vector y-arr)
			       (print-vector dydt-arr)) pe-sim-1))
		('sim-model-717-rk4 (push (list time (print-vector y-arr)
						(print-vector dydt-arr))
					  pe-sim-d))
		(2 (push (list time (print-vector y-arr)
			       (print-vector dydt-arr)) pe-sim-2)))
	      ,@(loop for sexpr
		   in (assign-exo-vars (getv-exogenous-variables) 'time)
		   count 1 into counter
		   append (list 
			   #+DEBUG-PE-SIM
			   `(case (first pe-sim-cnt)
			      (1 (push ,(format nil "x-~A" counter) pe-sim-1))
			      ('sim-model-717-rk4 
			       (push ,(format nil "x-~A" counter) pe-sim-d))
			      (2 (push ,(format nil "x-~A" counter) pe-sim-2)))
				sexpr))
	      ,@(loop for sexpr
		   in (rk4-generate-f-equations system t)
		   count 1 into counter
		   append (list 
			   #+DEBUG-PE-SIM
			   `(case (first pe-sim-cnt)
			      (1 (push ,(format nil "f-~A" counter) pe-sim-1))
			      ('sim-model-717-rk4 
			       (push ,(format nil "f-~A" counter) pe-sim-d))
			      (2 (push ,(format nil "f-~A" counter) pe-sim-2)))
			   sexpr)))
	   #+DEBUG-HOLD-FOR-GETTING-RID-OF-DEBUGS-IN-PREV-SEXPR
	   `(lambda (time y-arr dydt-arr) 
	      (declare		      ;(optimize (speed 3) (safety 0))
	       (double-float time)
	       (ignorable time y-arr dydt-arr)
	       (special *algebraic-variables* *exogenous-variables*
			*system-variables* *model-constants*)
	       ;; (type (simple-array double-float *) y-arr dydt-arr
	       ;;     *algebraic-variables* *exogenous-variables*
	       ;;     *system-variables* *model-constants*)
	       )
	      ;;       (incf *model-counter*)
	      ,@(assign-exo-vars (getv-exogenous-variables) 'time)
	      ,@(rk4-generate-f-equations system t)))
	  (compile
	   NIL
	   `(lambda (time y-arr) 
	      (declare		      ;(optimize (speed 3) (safety 0))
	       (double-float time)
	       (ignorable time y-arr)
	       (special *algebraic-variables* *exogenous-variables*
			*system-variables* *model-constants*)
	       ;; (type (simple-array double-float *) y-arr dydt-arr
	       ;;     *algebraic-variables* *exogenous-variables*
	       ;;     *system-variables* *model-constants*)
	       )
	      ,@(assign-exo-vars (getv-exogenous-variables) 'time)
	      ,@(rk4-generate-f-equations system nil)))))

#+COMPILED-LAMBDA
(defun rk4-make-model (system)
	(values `(lambda (time y-arr dydt-arr)
		   (declare (optimize (speed 3) (safety 0))
			    (double-float time)
			    (type (simple-array double-float) y-arr dydt-arr)
			    (ignorable time y-arr dydt-arr)
			    (sb-ext:muffle-conditions sb-ext:compiler-note))
		   ,@(assign-exo-vars (getv-exogenous-variables) 'time)
		   ,@(rk4-generate-f-equations system t))
		`(lambda (time y-arr) 
		   (declare (optimize (speed 3) (safety 0))
			    (double-float time)
			    (type (simple-array double-float) y-arr)
			    (ignorable time y-arr)
			    (sb-ext:muffle-conditions sb-ext:compiler-note))
		   ,@(assign-exo-vars (getv-exogenous-variables) 'time)
		   ,@(rk4-generate-f-equations system nil))))

#-COMPILED-LAMBDA
(defun rk4-make-model (system)
  ;;  (setf *model-counter* 0)
	`(progn
	   ,(append '(defun rk4_model (time y-arr dydt-arr) 
		      (declare (optimize (speed 3) (safety 0))
		       (double-float time)
		       (type (simple-array double-float) y-arr dydt-arr)
		       (ignorable time y-arr dydt-arr))
		      ;; (incf *model-counter*)
		      #+NOT
		      (push (list :y-arr (coerce y-arr 'list)
			     :dydt-arr (coerce dydt-arr 'list)
			     :model-constants (coerce *model-constants* 'list)
			     :algebraic-variables (coerce *algebraic-variables* 'list)
			     :system-variables (coerce *system-variables* 'list)
			     :time time)
		       *rk4-par-list*))
		    (assign-exo-vars (getv-exogenous-variables) 'time)
		    (rk4-generate-f-equations system t))
	   ,(append '(defun rk4_model_no_diffeq (time y-arr) 
		      (declare (optimize (speed 3) (safety 0))
		       (double-float time)
		       (type (simple-array double-float) y-arr)
		       (ignorable time y-arr))
		      #+NOT
		      (push (list :y-arr (coerce y-arr 'list)
			     :model-constants (coerce *model-constants* 'list)
			     :algebraic-variables (coerce *algebraic-variables* 'list)
			     :system-variables (coerce *system-variables* 'list)
			     :time time)
		       *rk4-alg-par-list*))
		    (assign-exo-vars (getv-exogenous-variables) 'time)
		    (rk4-generate-f-equations system nil))))


(defun rk4-generate-f-equations (system diffeq?)
  (let ((alg-eqs (order-algebraic-equations (remove-if #'differential-equation-p system)))
	(diff-eqs (remove-if #'algebraic-equation-p system))
	(eqs))
    ;; first, take care of the differential equations if necessary
    (when diffeq?
      (dolist (e diff-eqs)
	(push `(setf (aref dydt-arr
			   ,(car (gethash (diff-eq-variable e) (get-var-idx-map))))
		     ,(rk4-replace-vars-consts (diff-eq-rhs e) diffeq?))
	      eqs)))
    ;; now process the algebraic equations
    (dolist (e alg-eqs)
      (push `(setf (#+clisp svref #-clisp aref 
			    *algebraic-variables*
			    ,(car (gethash (alg-eq-variable e) (get-var-idx-map))))
		   ,(rk4-replace-vars-consts (alg-eq-rhs e) diffeq?))
	    eqs))
    eqs))

(defun rk4-replace-vars-consts (eq rk4?)
  (cond ((atom eq)
	 eq)
	((or (variable?-p (cdr eq))
	     (constant?-p (cdr eq)))
	 (let ((pos (gethash eq (get-var-idx-map))))
	   (cond ((eq (cdr pos) 'ALG)
		  `(#+clisp svref #-clisp aref *algebraic-variables* ,(car pos)))
		 ((eq (cdr pos) 'SYS)
		  `(aref y-arr ,(car pos)))
		 ((eq (cdr pos) 'EXO)
		  `(#+clisp svref #-clisp aref *exogenous-variables* ,(car pos)))
		 ((eq (cdr pos) 'CON)
		  `(#+clisp svref #-clisp aref *model-constants* ,(car pos))))))
	(t 
	 (cons (rk4-replace-vars-consts (car eq) rk4?)
	       (rk4-replace-vars-consts (cdr eq) rk4?)))))

#+NOT-USED
(defun rk4-simulate (model start-time end-time step-size)
  (declare (double-float start-time)
	   (double-float end-time)
	   (double-float step-size))
  (when model
    (rk4-prepare-model model)
    (setf *data-sets* (list (read-data-from-file "rsp-yr1-ciao.data")))
    (setf *current-data-set* (car *data-sets*))
    ;; match the initial conditions with their prespecified value
    (rk4-data-init *current-data-set*)
    (combined-sim-rk4 *current-data-set*
		      :start-time start-time 
		      :end-time end-time 
		      :step-size step-size 
		      :track-all? t)))

;;; The following function isn't currently referenced anywhere in SCIPM.
;;; It sets *data-sets* and *current-data-sets* and is NOT thread safe.
#+NOT-USED-NOT-THREADSAFE
(defun rk4-simulate-data (model datasets)
  (let (ret)
    (when (and model datasets)
      (setf *data-sets* datasets)
      (rk4-prepare-model model)
      (dolist (d datasets ret)
	(declare (ignorable d))
	(setf *current-data-set* (car *data-sets*))
	;; match the initial conditions with their prespecified value
	(rk4-data-init *current-data-set*)
	(push (combined-sim-rk4 *current-data-set* :track-all? t) ret)))))

(defun rk4-store-data-vector (sim-time &optional track-all?)
  (let ((lst))
    (when (and track-all? (> (array-dimension *exogenous-variables* 0) 0)) 
      (setf lst (append (simple-array-to-list *exogenous-variables*) lst)))
    (when (> (array-dimension *system-variables* 0) 0)
      (setf lst (append (simple-array-to-list *system-variables*) lst)))
    (when (and track-all? (> (array-dimension *system-variables* 0) 0)) 
      (setf lst (append (simple-array-to-list *algebraic-variables*) lst)))
    (setf lst (cons sim-time lst))
    (apply #'vector lst)))

#+COMPILED-LAMBDA
(defun rk4-prepare-model (model)
  ;; getting rid of the eval - heh
  (declare (special rk4_model_fnc rk4_model_no_diffeq_fnc))
  ;; create the model for simulation
  (multiple-value-bind (f1 f2)
		  (make-rk4-model model (build-equations model))
    (setf rk4_model_fnc (compile NIL f1)
	  rk4_model_no_diffeq_fnc (compile NIL f2))))

#-COMPILED-LAMBDA
(defun rk4-prepare-model (model)
  ;; create the model for simulation
  (eval (make-rk4-model model (build-equations model)))
  #-SBCL
  (compile 'rk4_model)
  #-SBCL
  (compile 'rk4_model_no_diffeq))

(defun rk4-data-init (d)
  ;; match the initial conditions with their values in the data file
  ;; or the current defaults
  (let ((cvode-init-values (cvode-initial-data-values d)))
    (setf *system-variables* (make-array (length cvode-init-values)
					 :element-type 'double-float))
    (loop for x in cvode-init-values
       for i from 0 to (1- (length cvode-init-values))
       do (setf (aref *system-variables* i) x))))

;; RAB - references undefined global variable "predprey"
;;; (defun test-rk4 () (rk4-simulate predprey 8.5d0 35d0 0.5d0))