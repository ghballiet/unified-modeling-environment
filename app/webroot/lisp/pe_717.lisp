(in-package :scipm)

;;;;;;;;;;;;;;;;; 717 Parameter Estimation ;;;;;;;;;;;;;;;;;;;;;;;
;;
;; this file defines a parameter estimation routine that uses 
;; TOMS algorithm 717.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#+DEBUG-TRACER
(defmacro tracer (string)
	  `(with-open-file (trace-output "~/isle/scipm/trace.txt"
					 :direction :output
					 :if-exists :append 
					 :if-does-not-exist :create)
	     (format trace-output "~A~%" ,string)))

#+DEBUG-TRACER-ALL
(defmacro tracer-all (string)
	  `(with-open-file (trace-output "~/isle/scipm/trace-all.txt"
					 :direction :output
					 :if-exists :append 
					 :if-does-not-exist :create)
	     (format trace-output "~A~%" ,string)))

;; the static ordering of system variables used by algorithm 717
#-THREADED-SCIPM
(defvar *717-var-order* nil)

#+THREADED-SCIPM
(declaim 
 (special *system-variables* *model-constants* *717-var-order*)
 #+DEBUG-PE-SIM (special pe-sim-cnt pe-model-val)
 (type (simple-array double-float *) *system-variables* *model-constants*))

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
;;
;;;; XXX: not handling initial conditions of variables yet.

#+DEBUG-PE-SIM
(defun current-thread-name () (slot-value (current-thread) 'sb-thread::name))

#+NON-PE-SIM
(defun pe-717 (model data ordered-constants sim-function init-function sim-error? 
               pe-sim-function pe-eval-function n-restarts
               &key (obj-f #'sse) (obj-better? #'<) 
               ;; (fit-initial-values nil)
               (normalize t)
               (suppress-sim nil))
  (let ((best-score)
        (best-params)
        ;; (param-hash  (make-hash-table :test 'equal))

        (current-score)
        (best-sim)
        (eval-params (make-array 1 :element-type 'f2cl-lib::integer4))
        (n-params (length *model-constants*))
        (n-observations (* (length *system-variables*) 
                           (apply #'* (mapcar #'(lambda (x) (length (data-values x))) data))))
        ;; l-iv, l-v, iv, v
        ;; temporary working space for 717 and the size of that space
        (l-iv) (l-v) (iv) (v)
        ;; bounds-717
        ;; [0..(2*n-params-1)]: lower and upper bounds of the parameter values. 
        ;; bounds-717[2*i] is the lower and bounds-717[2*i+1] is the upper 
        ;; bound for the i-th parameter.
        (bounds-717 (make-array (* 2 (array-dimension ordered-constants 0)) 
                                :element-type 'double-float))
        (bounds-lst (get-constant-bounds ordered-constants))
        #+DEBUG-PE-SIM pe-sim-1 #+DEBUG-PE-SIM pe-sim-D #+DEBUG-PE-SIM pe-sim-2)
    #+DEBUG-PE-SIM (declare (special pe-sim-1 pe-sim-D pe-sim-2))
    (setf *717-var-order* (get-717-var-order model))
    ;; see ALG-717 paper
    ;; the length of the temporary storage for ALG-717
    (setf l-iv (+ (* 5 n-params) 82))
    (setf l-v (+ (* n-observations (+ n-params 6)) (* 4 n-params) 
                 (* n-params (+ (* 2 n-params) 20)) 105))
    (setf iv (make-array l-iv :element-type 'f2cl-lib::integer4))
    (setf v (make-array l-v :element-type 'double-float))
    ;; eval-params[0] = normalization flag
    (setf (aref eval-params 0) (if normalize 1 0))
    
    ;; the parameter array will just be *model-constants* for now.  we
    ;; will extend this to include any number of initial conditions or
    ;; to turn on/off some constants for estimation by creating a
    ;; second array specifically for pe_717

    ;; create the bounds array for 717
    (dotimes (idx n-params)
      (setf (aref bounds-717 (* 2 idx)) (aref (second bounds-lst) idx))
      (setf (aref bounds-717 (+ 1 (* 2 idx))) (aref (first bounds-lst) idx)))

    ;; pair the constants with their values
    ;; RAB - if f2cl::dglfb fail N times (N = n-restarts), then best-params will be NIL,
    ;;        not a vector and following code breaks.
    ;;       The fix for this case: test if a best params found,
    ;;        else (ie, if not) return NIL for the call to PE-717.
    ;;       Only call tree (run-scipm-random -> scipm-717-[rk4|cvode] -> pe-717)
    ;;        does the right thing with NIL value for this function.

    ;; GRH - not sure if this is necessary or not, since it is outside
    ;; of the main loop. it looks like it is just more parameter
    ;; estimation stuff, though. 

    #|
    (when best-params  ; added test remainder of the code is the same. ;
    (setf best-params
    (loop for c across ordered-constants and v across best-params
               ;; ordered-constants has the form ((generic . constant?) ...) ;
               ;; we only need the constant? to update the model ;
    collect (cons (cdr c) v)))
    (if suppress-sim
    (list best-params best-score)
    (list best-params best-score best-sim)))))
    |#

    ;; GRH - added final call to pe-simulate in order to actually
    ;; simulate the model... fingers crossed
    ;; RAB - If you expect everything to continue to work, you need to return
    ;;       the same number of values as the original function.  If the second
    ;;       value is NIL it thinks that the model didn't converge.  If you don't
    ;;       return the third value, it doesn't know where to find the sim-results.
    ;;       See above (list best-params best-score best-sim)?  You probably want
    ;;       the score as well as the sim results ...
    (let ((sim-vals (pe-simulate init-function sim-function sim-error? data)))
      (when sim-vals
	(setf current-score 
	      (apply #'+ 
		     (hash-table-vals 
		      (funcall obj-f sim-vals data normalize))))
	(list (copy-vector *model-constants*) current-score sim-vals)))))

#-NON-PE-SIM
(defun pe-717 (model data ordered-constants sim-function init-function sim-error? 
               pe-sim-function pe-eval-function n-restarts
               &key (obj-f #'sse) (obj-better? #'<) 
               ;; (fit-initial-values nil)
               (normalize t)
               (suppress-sim nil))
  (let ((best-score)
        (best-params)
        ;; (param-hash  (make-hash-table :test 'equal))

        (current-score)
        (best-sim)
        (eval-params (make-array 1 :element-type 'f2cl-lib::integer4))
        (n-params (length *model-constants*))
        (n-observations (* (length *system-variables*) 
                           (apply #'* (mapcar #'(lambda (x) (length (data-values x))) data))))
        ;; l-iv, l-v, iv, v
        ;; temporary working space for 717 and the size of that space
        (l-iv) (l-v) (iv) (v)
        ;; bounds-717
        ;; [0..(2*n-params-1)]: lower and upper bounds of the parameter values. 
        ;; bounds-717[2*i] is the lower and bounds-717[2*i+1] is the upper 
        ;; bound for the i-th parameter.
        (bounds-717 (make-array (* 2 (array-dimension ordered-constants 0)) 
                                :element-type 'double-float))
        (bounds-lst (get-constant-bounds ordered-constants))
        #+DEBUG-PE-SIM pe-sim-1 #+DEBUG-PE-SIM pe-sim-D #+DEBUG-PE-SIM pe-sim-2)
    #+DEBUG-PE-SIM (declare (special pe-sim-1 pe-sim-D pe-sim-2))
    (setf *717-var-order* (get-717-var-order model))
    ;; see ALG-717 paper
    ;; the length of the temporary storage for ALG-717
    (setf l-iv (+ (* 5 n-params) 82))
    (setf l-v (+ (* n-observations (+ n-params 6)) (* 4 n-params) 
                 (* n-params (+ (* 2 n-params) 20)) 105))
    (setf iv (make-array l-iv :element-type 'f2cl-lib::integer4))
    (setf v (make-array l-v :element-type 'double-float))
    ;; eval-params[0] = normalization flag
    (setf (aref eval-params 0) (if normalize 1 0))
    
    ;; the parameter array will just be *model-constants* for now.  we
    ;; will extend this to include any number of initial conditions or
    ;; to turn on/off some constants for estimation by creating a
    ;; second array specifically for pe_717

    ;; create the bounds array for 717
    (dotimes (idx n-params)
      (setf (aref bounds-717 (* 2 idx)) (aref (second bounds-lst) idx))
      (setf (aref bounds-717 (+ 1 (* 2 idx))) (aref (first bounds-lst) idx)))
    (let ((restart-idx 0) (error-flag))
      (while (< restart-idx n-restarts)
        (when (= restart-idx 0)
          #+DEBUG
          (with-open-file (trace-output "~/Desktop/scipm/trace.txt"
                                        :direction :output
                                        :if-exists :supersede
                                        :if-does-not-exist :create)
            (format trace-output ">>> ~A : ~A <<<~%" (slot-value model 'name) restart-idx))
          (with-open-file (trace-output "~/Desktop/scipm/trace-all.txt"
                                        :direction :output
                                        :if-exists :append
                                        :if-does-not-exist :create)
            (format trace-output ">>> ~A : ~A <<<~%~A~%" (slot-value model 'name) restart-idx
                    (model-processes model))))
        (randomize-parameters (array-dimension ordered-constants 0) 
                              (second bounds-lst)  (first bounds-lst))
        
        ;; make sure the model can simulate w/o error
        (when 
            (progn 
              #+DEBUG-PE-SIM
              (setf pe-sim-cnt (list 1 (slot-value model 'name) (current-thread-name)))
              #+THREADED-SCIPM
              (handler-case 
                  (pe-simulate init-function sim-function sim-error? data)
                (type-error (condition) 
                  (with-locked-var (*type-error-count*)
                    (push (list (slot-value model 'name) condition 
                                (loop for x from 0 
                                   to (1- (array-dimension *model-constants* 0))
                                   collect (aref *model-constants* x))
                                (slot-value (current-thread) 'sb-thread::name))
                          *type-error-count*))
                  nil))
              #-THREADED-SCIPM
              (pe-simulate init-function sim-function sim-error? data))

          ;; clear the temporary memory for 717
          (dotimes (idx l-v) (setf (aref v idx) 0d0))
          (dotimes (idx l-iv) (setf (aref iv idx) 0))

          ;; run alg-717
          
          ;; XXX: here's where we'll catch an error
          ;; wrap in (multiple-value-list (ignore-errors
          ;; if this is length 2, we have an error
          ;; skip ahead to the next random restart
          ;; consider whether we should count this as a restart
          #+DEBUG-PE-SIM
          (setf pe-model-val (list (list (coerce *model-constants* 'list) 
                                         (current-thread-name)
                                         (slot-value model 'name))))
          #+DEBUG-TRACER
          (tracer (format nil "PE-717:                         ~A" (slot-value model 'name)))
          (setf error-flag 
                (multiple-value-list 
                 (ignore-errors
                   (f2cl::dglfb n-observations n-params n-params 
                                        ;(make-array (array-dimension *model-constants* 0)
                                        ;            :element-type 'double-float
                                        ;            :initial-contents *model-constants*)
                                *model-constants*
                                bounds-717 pe-eval-function eval-params 
                                (make-array 0 :element-type 'double-float) iv l-iv l-v v
                                pe-sim-function
                                (make-array 0 :element-type 'f2cl-lib::integer4) 
                                (make-array 0 :element-type 'double-float) nil))))
          #+DEBUG-PE-SIM
          (with-locked-var (*error-flag*)
            (push (list error-flag (slot-value model 'name) 
                        (current-thread-name))
                  *error-flag*))
          #+DEBUG-PE-SIM
          (push (list *model-constants* (current-thread-name) (slot-value model 'name))
                pe-model-val)
          (unless (second error-flag)
            ;; simulate the resulting model and update the best
            ;; parameters if needed
            (let ((sim-vals (progn 
                              #+DEBUG-PE-SIM (setf pe-sim-cnt 
                                                   (list 2 
                                                         (slot-value model 'name)
                                                         (current-thread-name) error-flag))
                              (pe-simulate init-function sim-function sim-error? data))))
                                        ;(print-data-set sim-vals)
              (when sim-vals
                (setf current-score 
                      (apply #'+ 
                             (hash-table-vals 
                              (funcall obj-f sim-vals data normalize))))
                ;; save the best score and parameters
                (when (or (null best-score) 
                          (funcall obj-better? current-score best-score))
                  (setf best-score current-score)
                  (setf best-sim sim-vals)
                  (setf best-params (copy-vector *model-constants*)))))) ;))

          (incf restart-idx))))

    ;; pair the constants with their values
    ;; RAB - if f2cl::dglfb fail N times (N = n-restarts), then best-params will be NIL,
    ;;        not a vector and following code breaks.
    ;;       The fix for this case: test if a best params found,
    ;;        else (ie, if not) return NIL for the call to PE-717.
    ;;       Only call tree (run-scipm-random -> scipm-717-[rk4|cvode] -> pe-717)
    ;;        does the right thing with NIL value for this function.
    (when best-params  ; added test remainder of the code is the same.
      (setf best-params
            (loop for c across ordered-constants and v across best-params
               ;; ordered-constants has the form ((generic . constant?) ...)
               ;; we only need the constant? to update the model
               collect (cons (cdr c) v)))
      (if suppress-sim
          (list best-params best-score)
          (list best-params best-score best-sim)))))

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-717-var-order
;;;
;;; returns a fixed ordering for the observed variables that ALG-717
;;; uses during its estimation routine.  the list does not include the
;;; identification variable (e.g., time).
(defun get-717-var-order (model) 
  (sort (remove (data-id-name (car *data-sets*))
		(intersection (data-names (car *data-sets*)) 
			      (mapcar #'(lambda (x) 
					  (read-from-string (variable?-data-name (cdr x))))
				      (get-observed-variables model))))
	#'(lambda (x y) (string-lessp (symbol-name x) (symbol-name y)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; specialized routines
;;;;
;;;; the FORTRAN conversion still requires archaic ways of passing
;;;; information around to avoid living too far in the pass, we'll store
;;;; the predicted values of the system variables in a local list
;;;;
;;;; this closure isn't necessary, but it simplifies some of the code
;;;; and lets us use a generic objective function as opposed to one
;;;; crafted specifically for this estimation procedure.

#-THREADED-SCIPM
(let ((predicted-717))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; eval-model-717-sse
;;;
;;; evaluate model simulation (stored in r) as required by ALG-717:
;;; need[0]: store model 0.5 * SSE in *f
;;; need[1]: store derivatives of the error for each point in r and rp
;;;          since error = 0.5 * ((y - yhat) / norm) ^ 2
;;;                d error / d y = (y - yhat) / norm
;;;                d2 error / d y2 = 1 / norm
;;; ui[0]: if 1, then normalize the error
;;; other parameters: see ALG-717 paper
  (defun eval-model-717-sse (need f n nf xn r rp ui ur w)
    (setf nf 1)
    (cond ((= (aref need 0) 1)
	   ;;;; OVERFLOW WARNING
	  ; (let ((error-flag))
	   ;  (setf error-flag 
	;	   (multiple-value-list 
	;	    (ignore-errors
	   ;; NOTE: allegro has problems with this handler case, and since it should generally
	   ;;       work when the simulation succeeds, there's no pressing reason to add it in.
	   (unless (handler-case 
		     ;; test
		      (setf f (* 0.5 (apply #'+ (hash-table-vals 
						 (sse predicted-717 *data-sets* (= 1 (aref ui 0)))))))
		   ;; type
		     ((or floating-point-overflow
		       #+allegro floating-point-invalid
		       #+allegro division-by-zero
		       floating-point-underflow) 
			 ;; var
			 (var)
		       ;; expression
		       (progn (print var) nil)))
	     (print "ERROR")
	     (setf nf 0)))
		  ;    )))
	;     (when (second error-flag)
	;       (setf nf 0))))
	  (t
	   ;; r is an array that runs the length of the data.  you can find the value for 
	   ;; variable n in datum m by looking at r[n*m] where
	   ;; max(m) == length(all the data sets) - 1.
	   (let ((disp-map (data-dispersions))
		 (vidx 0)  ;; index of the current variable as it relates to the r array
		 dsidx     ;; index of the current data set from the list of all data sets
		 adidx     ;; absolute index of the current datum
		 ;; total number of data
		 (ndata (apply #'+ (mapcar #'(lambda (x) (data-length x)) *data-sets*)))
		 )
	     ;; walk through each variable -- vidx
	     (dolist (v *717-var-order*)
	       (setf adidx 0)
	       (setf dsidx 0)
	       ;; prepare the normalization factor
	       (let ((norm (if (= 1 (aref ui 0)) (gethash v disp-map) 1)))
		 ;; walk through each datum in each data set in order -- didx		 
		 (dolist (dset *data-sets*)
		   (dotimes (didx (data-length dset))
		     ;; evaluate the first derivative of the error function
		     ;; r[vidx * ndata + adidx] = (r[vidx * ndata + adidx] - data[vidx, didx]) / norm;
		     ;; rp[vidx * ndata + adidx] = 1 / norm;
		     (setf (aref r (+ (* vidx ndata) adidx))
			   (/ (- (aref r (+ (* vidx ndata) adidx)) 
				 (datum-value (datum dset didx) v dset))
			      norm))
		     ;; evaluate the second derivative of the error function
		     (setf (aref rp (+ (* vidx ndata) adidx))
			   (/ 1d0 norm))
		     (incf adidx))
		   (incf dsidx)))
	       (incf vidx)))))
    ;; return multiple arguments using a "values" call to emulate pass
    ;; by reference in fortran.
    (values need f n nf xn r rp ui ur w))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sim-model-717-cvode
;;;
;;; simulates the model using CVODE and stores the results in the
;;; appropriate data structure for alg-717.
  (defun sim-model-717-cvode (n p x nf need r rp ui ur uf)

    (setf predicted-717 
	  (pe-simulate #'cvode-data-init #'combined-sim-cvode
		       #'cvode-sim-error? *data-sets*))

    ;; abort immediately if we ran into an error
    ;; overwriting predicted-717 automatically discards any results
    (unless predicted-717
      (setf nf 0)
      (return-from sim-model-717-cvode (values n p x nf need r rp ui ur uf)))
    
    ;; prepare to report "all's well" to 717
    (setf nf 1)
    
    (let ((dsidx 0) ;; index of the current data set
	  (adidx 0) ;; absolute index of the current datum (across data sets)
	  ;; total number of data points
	  (ndata (apply #'+ (mapcar #'(lambda (x) (data-length x)) *data-sets*))))
      
      ;; walk through each data set
      (dolist (results predicted-717)
	;; store the results for the observed variables in the 717 structure
	;; walk through each datum in the current data set -- didx
	(dotimes (didx (data-length results))
	  (let ((vidx 0))  ;; index of the current variable as it relates to the r array
	    ;; walk through each variable -- vidx
	    (dolist (v *717-var-order*)
	      ;; store the value of the current variable
	      (setf (aref r (+ (* vidx ndata) adidx))
		    (datum-value (datum results didx) v results))
	      (incf vidx)))
	  (incf adidx))
	(incf dsidx)))
    (values n p x nf need r rp ui ur uf))


  (defun sim-model-717-rk4 (n p x nf need r rp ui ur uf)

    (setf predicted-717
	  (progn #+DEBUG-PE-SIM (setf pe-sim-cnt 'sim-model-717-rk4)
		 (pe-simulate #'rk4-data-init #'combined-sim-rk4 
		       #'rk4-sim-error? *data-sets*)))

    ;; abort immediately if we ran into an error
    ;; overwriting predicted-717 automatically discards any results
    (unless predicted-717
      (setf nf 0)
      (return-from sim-model-717-rk4 (values n p x nf need r rp ui ur uf)))
    
    ;; prepare to report "all's well" to 717
    (setf nf 1)
    
    (let ((dsidx 0) ;; index of the current data set
	  (adidx 0) ;; absolute index of the current datum (across data sets)
	  ;; total number of data points
	  (ndata (apply #'+ (mapcar #'(lambda (x) (data-length x)) *data-sets*))))
      
      ;; walk through each data set
      (dolist (results predicted-717)
	;; store the results for the observed variables in the 717 structure
	;; walk through each datum in the current data set -- didx
	(dotimes (didx (data-length results))
	  (let ((vidx 0))  ;; index of the current variable as it relates to the r array
	    ;; walk through each variable -- vidx
	    (dolist (v *717-var-order*)
	      ;; store the value of the current variable
	      (setf (aref r (+ (* vidx ndata) adidx))
		    (datum-value (datum results didx) v results))
	      (incf vidx)))
	  (incf adidx))
	(incf dsidx)))
    (values n p x nf need r rp ui ur uf))

) ;; ends the closure

#+THREADED-SCIPM
(declaim (special predicted-717))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; eval-model-717-sse
;;;
;;; evaluate model simulation (stored in r) as required by ALG-717:
;;; need[0]: store model 0.5 * SSE in *f
;;; need[1]: store derivatives of the error for each point in r and rp
;;;          since error = 0.5 * ((y - yhat) / norm) ^ 2
;;;                d error / d y = (y - yhat) / norm
;;;                d2 error / d y2 = 1 / norm
;;; ui[0]: if 1, then normalize the error
;;; other parameters: see ALG-717 paper
#+THREADED-SCIPM
(defun eval-model-717-sse (need f n nf xn r rp ui ur w)
  (declare (special predicted-717))
  #+DEBUG-TRACER
  (tracer (format NIL "EVAL-MODEL-717-SSE: ~A" (if predicted-717 t 'f)))
  (setf nf 1)
  (cond ((= (aref need 0) 1)
         ;;;; OVERFLOW WARNING
					; (let ((error-flag))
					;  (setf error-flag 
					;	   (multiple-value-list 
					;	    (ignore-errors
	 ;; NOTE: allegro has problems with this handler case, and since it should generally
	 ;;       work when the simulation succeeds, there's no pressing reason to add it in.
	 #+DEBUG-TRACER
	 (tracer (format NIL "  ===:>- (aref need 0) = 1"))
	 (unless
	     (handler-case 
		 ;; test
		 (setf f (* 0.5 
			    (apply #'+ (hash-table-vals 
					(sse predicted-717 *data-sets* (= 1 (aref ui 0)))))))
	       ;; type
	       ((or floating-point-overflow
		 #+allegro floating-point-invalid
		 #+allegro division-by-zero
		 floating-point-underflow) 
		   ;; var
		   (var)
		 ;; expression
		 (progn (print var) 
			#+DEBUG-TRACER
			(tracer "  ===:>- floating-point-under/overflow")
			nil)))
	   (print "ERROR")
	   #+DEBUG-TRACER
	   (tracer "  ===:>- print error")
	   (setf nf 0)))
					;    )))
					;     (when (second error-flag)
					;       (setf nf 0))))
	(t
	 #+DEBUG-TRACER 
	 (tracer "  --->")
	 ;; r is an array that runs the length of the data.  you can find the value for 
	 ;; variable n in datum m by looking at r[n*m] where
	 ;; max(m) == length(all the data sets) - 1.
	 (let ((disp-map (data-dispersions))
	       (vidx 0)	;; index of the current variable as it relates to the r array
	       dsidx ;; index of the current data set from the list of all data sets
	       adidx ;; absolute index of the current datum
	       ;; total number of data
	       (ndata (apply #'+ (mapcar #'(lambda (x) (data-length x)) *data-sets*)))
	       )
	   ;; walk through each variable -- vidx
	   (dolist (v *717-var-order*)
	     (setf adidx 0)
	     (setf dsidx 0)
	     ;; prepare the normalization factor
	     (let ((norm (if (= 1 (aref ui 0)) (gethash v disp-map) 1)))
	       ;; walk through each datum in each data set in order -- didx		 
	       (dolist (dset *data-sets*)
		 (dotimes (didx (data-length dset))
		   ;; evaluate the first derivative of the error function
		   ;; r[vidx * ndata + adidx] = (r[vidx * ndata + adidx] - data[vidx, didx]) / norm;
		   ;; rp[vidx * ndata + adidx] = 1 / norm;
		   (setf (aref r (+ (* vidx ndata) adidx))
			 (/ (- (aref r (+ (* vidx ndata) adidx)) 
			       (datum-value (datum dset didx) v dset))
			    norm))
		   ;; evaluate the second derivative of the error function
		   (setf (aref rp (+ (* vidx ndata) adidx))
			 (/ 1d0 norm))
		   (incf adidx))
		 (incf dsidx)))
	     (incf vidx)))))
  ;; return multiple arguments using a "values" call to emulate pass
  ;; by reference in fortran.
  #+DEBUG-TRACER
  (tracer (format nil "   *M-C*:~A" (print-vector *model-constants*)))
  (values need f n nf xn r rp ui ur w))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sim-model-717-cvode
;;;
;;; simulates the model using CVODE and stores the results in the
;;; appropriate data structure for alg-717.
#+THREADED-SCIPM
(defun sim-model-717-cvode (n p x nf need r rp ui ur uf)
  (declare (special predicted-717))
  (setf predicted-717 
	(pe-simulate #'cvode-data-init #'combined-sim-cvode
		     #'cvode-sim-error? *data-sets*))

  ;; abort immediately if we ran into an error
  ;; overwriting predicted-717 automatically discards any results
  (unless predicted-717
    (setf nf 0)
    (return-from sim-model-717-cvode (values n p x nf need r rp ui ur uf)))
    
  ;; prepare to report "all's well" to 717
  (setf nf 1)
    
  (let ((dsidx 0) ;; index of the current data set
	(adidx 0) ;; absolute index of the current datum (across data sets)
	;; total number of data points
	(ndata (apply #'+ (mapcar #'(lambda (x) (data-length x)) *data-sets*))))
      
    ;; walk through each data set
    (dolist (results predicted-717)
      ;; store the results for the observed variables in the 717 structure
      ;; walk through each datum in the current data set -- didx
      (dotimes (didx (data-length results))
	(let ((vidx 0))	;; index of the current variable as it relates to the r array
	  ;; walk through each variable -- vidx
	  (dolist (v *717-var-order*)
	    ;; store the value of the current variable
	    (setf (aref r (+ (* vidx ndata) adidx))
		  (datum-value (datum results didx) v results))
	    (incf vidx)))
	(incf adidx))
      (incf dsidx)))
  (values n p x nf need r rp ui ur uf))


#+THREADED-SCIPM
(defun sim-model-717-rk4 (n p x nf need r rp ui ur uf)
  (declare (special predicted-717))
 #+DEBUG-TRACER 
 (tracer (format NIL "SIM-MODEL-717-RK4: ~A; *M-C*= ~A" 
		 (if predicted-717 t 'f)
		 (print-vector *model-constants*)))
  (setf predicted-717
	(progn #+DEBUG-PE-SIM 
	       (setf pe-sim-cnt (list 'sim-model-717-rk4
				      ;; (slot-value model 'name) 
				      (current-thread-name)))
	       (pe-simulate #'rk4-data-init #'combined-sim-rk4 
			    #'rk4-sim-error? *data-sets*)))

  ;; abort immediately if we ran into an error
  ;; overwriting predicted-717 automatically discards any results
  (unless predicted-717
    (setf nf 0)
    (return-from sim-model-717-rk4 (values n p x nf need r rp ui ur uf)))
    
  ;; prepare to report "all's well" to 717
  (setf nf 1)
    
  (let ((dsidx 0) ;; index of the current data set
	(adidx 0) ;; absolute index of the current datum (across data sets)
	;; total number of data points
	(ndata (apply #'+ (mapcar #'(lambda (x) (data-length x)) *data-sets*))))
      
    ;; walk through each data set
    (dolist (results predicted-717)
      ;; store the results for the observed variables in the 717 structure
      ;; walk through each datum in the current data set -- didx
      (dotimes (didx (data-length results))
	(let ((vidx 0))	;; index of the current variable as it relates to the r array
	  ;; walk through each variable -- vidx
	  (dolist (v *717-var-order*)
	    ;; store the value of the current variable
	    (setf (aref r (+ (* vidx ndata) adidx))
		  (datum-value (datum results didx) v results))
	    (incf vidx)))
	(incf adidx))
      (incf dsidx)))
  (values n p x nf need r rp ui ur uf))
