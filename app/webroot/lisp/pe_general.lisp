(in-package :scipm)

(declaim (special *model-constants* *current-data-set*)
	 (type (simple-array double-float *) *model-constants*))

;; randomize the initial parameter values
(defun randomize-parameters (n lower-bounds upper-bounds &optional constants)
  (unless constants (setf constants *model-constants*))
  (dotimes (idx n)
    (setf (aref constants idx) 
	  (+ (aref lower-bounds idx) 
	     (random (- (aref upper-bounds idx) 
			(aref lower-bounds idx)))))))

#+DEBUG-SIM-CNT
(defun print-vector (vector) (format nil "~A" (coerce vector 'list)))

#+DEBUG-SIM-CNT
(defun save-sim-state ()
  (declare 
   (special alg-array sys-array exo-array const-array var-idx-map
	    rk4_model_fnc rk4_model_no_diffeq_fnc
	    *algebraic-variables* *exogenous-variables* *system-variables*
	    *model-constants*
	    *current-data-set* *717-var-order* predicted-717
	    #+DEBUG-ODE *debug-ode* #+DEBUG-ODE *debug-non-ode*
	    #+DEBUG-SIM-CNT pe-sim-cnt #+DEBUG-SIM-CNT pe-model-val)
   (type (simple-array double-float *)
	 *algebraic-variables* *exogenous-variables*
	 *system-variables* *model-constants*))
  (list `(:alg-array ,(print-vector alg-array))
	`(:sys-array ,(print-vector sys-array))
	`(:exo-array ,(print-vector exo-array))
	`(:const-array ,(print-vector const-array))
	`(:var-idx-map ,var-idx-map)
	;; the following were defvar'd in global.lisp, need to be local to thread
	`(:*algebraic-variables* ,(print-vector *algebraic-variables*))
	`(:*exogenous-variables* ,(print-vector *exogenous-variables*))
	`(:*system-variables* ,(print-vector *system-variables*))
	`(:*model-constants* ,(print-vector *model-constants*))
	`(:*717-var-order* ,*717-var-order*)
	`(:predicted-717 ,predicted-717)
	;; the following will have a compiled function bound to them 
	#+DEBUG-ODE
	`(:*debug-ode* ,*debug-ode*) 
	#+DEBUG-ODE
	`(:*debug-non-ode* ,*debug-non-ode*)))

(defun pe-simulate (init-f sim-f sim-error? data)
  (declare (special pe-sim-cnt pe-sim-1 pe-sim-D pe-sim-2))
  (let ((tmp-results))
    (mapcar #'(lambda (d) 
		(setf *current-data-set* d)
		(funcall init-f d)
		#+DEBUG-SIM-CNT
		(case (first pe-sim-cnt)
		  (1 (setf pe-sim-1 (save-sim-state)))
		  ('sim-model-717-rk4 (setf pe-sim-D (save-sim-state)))
		  (2 (setf pe-sim-2 (save-sim-state))))
		(setf tmp-results (funcall sim-f d))
		(if (or (funcall sim-error? (second tmp-results))
			;; SBCL will return a value instead of an error when dealing with
			;; results of arithmetic out-of-range floating points - so we look
			;; for a signature return value. This is necessary because of
			;; sbcl::get-floating-point-modes
			#+SBCL
			(loop for vector
			   in (coerce (data-values (first tmp-results)) 'list)
			   do (loop for x
				 in (coerce vector 'list)
				 when (equal x +DOUBLE-FLOAT-NAN+)
				 do (return T))))
		    (return-from pe-simulate nil)
		    (first tmp-results)))
	    data)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-constant-bounds
;;;
;;; given an array of constants, this function returns a list
;;; containing two arrays.  the first array contains the upper bounds
;;; for the specified constants in the same order as they appear in
;;; the passed in array.  the second array contains the lower bounds.
;;;
(defun get-constant-bounds (constants)
  (let ((upper-bounds (make-array (array-dimension constants 0)))
	(lower-bounds (make-array (array-dimension constants 0))))
    ;; store the upper and lower bounds for each constant
    (dotimes (idx (array-dimension constants 0) (list upper-bounds lower-bounds))
      (let ((c (cdr (aref constants idx))))
	(setf (aref lower-bounds idx) 
	      (or (constant?-lower-bound c)
		  (constant-type-lower-bound (constant?-type c))))
	(setf (aref upper-bounds idx)
	      (or (constant?-upper-bound c)
		  (constant-type-upper-bound (constant?-type c))))))))