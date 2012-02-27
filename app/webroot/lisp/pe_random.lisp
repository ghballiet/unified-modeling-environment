(in-package :scipm)

;;;;;;;;;;;;;; Random Parameter Estimation ;;;;;;;;;;;;;;;;;;;;;;;
;;
;; this file defines a parameter estimation routine that guesses
;; random values within a specified interval for each constant in the
;; model.  the set of parameters that best satisfies the objective
;; function is returned.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declaim (special *model-constants*)
	 (type (simple-array double-float *) *model-constants*))

;; model = a process model 
;; data = the data to fit
;; ordered-constants = the actual constants as they are ordered in *model-constants*
;; sim-function = the function to call to simulate the model
;; init-function = the implementation specific function for initializing a simulation
;; obj-f = the objective function, which defaults to plain old SSE
;; fit-initial-values = if t, then fit the initial values of all differential equation variables
;;                      if nil, only fit the initial values of unobserved ones
;; obj-better? = the function that tells whether the score from an objective function is better 
;;               than a previous value.  defaults to (new < old)
(defun pe-random (model data ordered-constants sim-function init-function sim-error? n-restarts
		  &key (obj-f #'sse) (obj-better? #'<)
		  (fit-initial-values nil) 
		  (normalize t) (suppress-sim nil))
  (declare (ignore model fit-initial-values))
  (let ((best-score)
	(best-sim)
	(best-params)
	(current-score)
	(bounds-lst (get-constant-bounds ordered-constants)))

;;;; XXX: not handling initial conditions of variables yet.
    (let ((restart-idx 0))
      (while (< restart-idx n-restarts)
	
	(randomize-parameters (array-dimension ordered-constants 0) 
			      (second bounds-lst) (first bounds-lst))

	;; simulate model & calculate the objective function
	(let ((sim-vals (pe-simulate init-function sim-function sim-error? data)))
	
	  ;; assume: models that produce simulation errors are
	  ;;         undesirable.  we'll return to the beginning of
	  ;;         the loop w/o updating the restart counter.
	  (when sim-vals
	    (incf restart-idx)
	    (setf current-score 
		  (apply #'+ 
			 (hash-table-vals 
			  (funcall obj-f sim-vals data normalize))))
	    (print current-score)
	    ;; save the best score and parameters
	    (when (or (null best-score) 
		      (funcall obj-better? current-score best-score))
	      (setf best-score current-score)
	      (setf best-sim sim-vals)
	      (setf best-params (copy-vector *model-constants*)))))))

    ;; pair the constants with their values
    (setf best-params
	  (loop for c across ordered-constants and v across best-params
	     ;; ordered-constants has the form ((generic . constant?) ...)
	     ;; we only need the constant? to update the model
	     collect (cons (cdr c) v)))

    (if suppress-sim
	(list best-params best-score)
	(list best-params best-score best-sim))))

#+ignore
(defun test-pe ()
  (let ((datasets (list (read-data-from-file "foo.data")))
	(model predprey)
	(results)
	(init-val-list)
	(init-val-array))

    (cvode-prepare-model model nil)
    (setf init-val-list (cvode-initial-data-values nil))
    #-clisp (setf init-val-array 
		  (make-array (length init-val-list)
			      :element-type 'double-float
			      :initial-contents init-val-list))
    #+clisp (setf init-val-array (apply #'vector init-val-list))

    (fill_in (coerce (datum-time (car datasets) 0) 'double-float) 
	     #+cmu (sys:vector-sap init-val-array)
	     #-cmu init-val-array
             0)
    (setf results (pe-random model datasets (getv-constants) 
			     #'combined-sim-cvode #'cvode-data-init #'cvode-sim-error? 10))

    (cvode-clean-up)
    results))

