(in-package :scipm)

;;;;;;;;;;;;;; Objective Functions for Estimation;;;;;;;;;;;;;;;;;
;;
;; this file defines objective functions for use with parameter
;; estimation.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;
;;;
;;; sse
;;; calculate the squared error between two lists of data sets 
;;;
;;; assumes that the data were sampled at *exactly* the same time
;;; points in each set.  (all unique identifiers are the same and in
;;; the same order.)
;;;
;;; assumes that all the observed data sets contain the same variables
;;; and all the predicted data sets contain the same variables, but
;;; does not assume that these two variable lists are identical
;;;
;;; assumes that the order that the data sets arrive in order so that
;;; the first predicted data set should be compared to the first
;;; observed and so on.
;;;
;;; only calculates SSE for the variables in both observed and
;;; predicted
;;;
;;; returns a mapping between the variables and their squared error
;;; over all the provided data sets
(defun sse (predicted observed &optional (normalize))
  (let ((var-map (make-hash-table))
	(var-lst 
	 ;; grab all the variables in both data sets except the unique id
	 (remove (data-id-name (car observed))
		    (intersection (data-names (car observed)) 
				  (data-names (car predicted))))))
    ;; initialize the sse for the variables that are both observed and
    ;; predicted
    (mapcar #'(lambda (x) (setf (gethash x var-map) 0)) var-lst)
    ;; loop through the data sets
    (mapc #'(lambda (obs pred)
	      (dotimes (idx (data-length obs))
		;; loop through the individual data
		(let ((od (datum obs idx))
		      (pd (datum pred idx)))
		  ;; loop through the variables
		  (dolist (v var-lst)
		    ;; collect the squared error

		    ;;;; OVERFLOW WARNING
		    ;; we can get an overflow here when we square the error.
		    ;; in that case, we will return the largest possible number.
		    (unless (handler-case
				(incf (gethash v var-map) 
				      (expt (- (datum-value od v obs) (datum-value pd v pred))
					    2))
			      ;; type
			      ((or floating-point-overflow
				;;#+allegro floating-point-invalid
				;;#+allegro division-by-zero
				;;floating-point-underflow
				) 
				  ;; var
				  (var)
				;; expression
				(progn (print var)
				       #+DEBUG-TRACER
				       (tracer "SSE - floating-point-overflow")
				       nil)))
		      (setf (gethash v var-map) most-positive-double-float))))))
	  observed predicted)
    ;; normalize the SSEs if necessary using normalization factors for
    ;; each variable that must have already been calculated and stored.
    (when normalize
      (let ((norm-table (data-dispersions)))
	(dolist (v var-lst)
	  (setf (gethash v var-map) (/ (gethash v var-map) (gethash v norm-table))))))
   var-map))



