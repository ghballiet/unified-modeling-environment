(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;; COMBINE EQUATIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;; These functions build a system of equations from a process model
;;;;; representation.  The end result is a list of (conditioned)
;;;;; equations that need to have their symbolic variables/constants
;;;;; replaced with CVODE friendly variables
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; given a list of conditions paired with equations
;; see: build-equations
;;
;; returns a list of equations that may have conditions on particular
;; components. all the equations will be combined according to the
;; proper aggregation method for the variable on the LHS.
(defun combine-equations (lst)
  (let ((equations (make-hash-table :test #'equal))
	(gp-marked (= 3 (length (first lst)))))
    ;; walk through each conditions--equations pairing
    (dolist (tuple lst)
      (let ((condition (when (car tuple)
			 (cons 'and (car tuple))))
	    (gp-mark (when gp-marked (third tuple))))
	(dolist (eq (second tuple))
	  (let* ((equation-variable (equation-variable eq))
		 (shared-var-equation (gethash equation-variable equations)))
	    (if shared-var-equation
		(setf (gethash equation-variable equations)
		      (aggregate-equation (if gp-marked
					      (list eq `(:gp ,gp-mark))
					      eq)
					  shared-var-equation
					  condition))
		(setf (gethash equation-variable equations)
		      (condition-equation (if gp-marked 
					      (list eq `(:gp ,gp-mark))
					      eq)
					  condition)))))))
    (hash-table-vals equations)))

;; given an equation, an associated condition, and a name for that condition
;; 
;; returns a copy of the equation such that if condition is not nil,
;; the RHS of the equation is processed with add-condition
;;
;; NOTE: the RHS is a deep copy, everything else is shallow.

(defun condition-equation (eq condition)
  (let* ((real-eq (if (listp eq) (first eq) eq))
	 (gp-mark (when (listp eq) (cdr eq)))
	 (variable (equation-variable real-eq))
	 (rhs (equation-rhs real-eq)))
    (if (differential-equation-p real-eq)
	;; ASSUME: all equations with the same left hand side ;
	;; are taken with respect to the same variable and are ;
	;; of the same order		;
	(make-differential-equation
	 :variable variable
	 :respect-to (diff-eq-respect-to real-eq)
	 :order (diff-eq-order real-eq)
	 :rhs (append gp-mark
		      (if condition
			  (add-condition (cdr variable) rhs condition)
			  (copy-tree rhs))))
	(make-algebraic-equation
	 :variable variable
	 :rhs (append gp-mark
		      (if condition
			  (add-condition (cdr variable) rhs condition)
			  (copy-tree rhs)))))))

;; given a variable, the RHS of an equation, and a condition
;; associated with the equation
;;
;; return the equation wrapped within a statement that tests the given
;; condition.  when the condition is false, a value dependent on the
;; variable's aggregation method is returned. (XXX: NOT YET TRUE)
;;
;; NOTE: the handling of default values assumes the use of aggregation
;; functions that can ignore '().
;; see: equation-aggregator
(defun add-condition (var rhs condition)
  (let ((agg (variable?-aggregator var)))
    (declare (ignorable agg))
    `(when ,condition
       ,(copy-tree rhs))))

;; applies the specified function to the given arguments
;; removes any occurrence of nil from the arguments and 
;;
;; returns the fn applied to the arguments. if the arguments list is
;; nil or if all its entries are nil, then 0 is returned.
;;
;; NOTE: when all processes shut off, the derivative should be set
;;       to zero since no further change in the value can occur.
(defun equation-aggregator (fn &rest args)
  (declare (optimize (speed 3) (safety 0)))
  (let ((tmp (delete nil args)))
    (if tmp
	(reduce fn tmp)
	0d0)))

;; given a differential or algebraic equation, new-eq, and a base
;; equation, base-eq, replace base-eq's RHS with the combination of
;; the RHS's of both base-eq and new-eq.
;;
;; destructive of the base-eq's RHS
;;
;; adds the appropriate conditions unless condition-name is nil
(defun aggregate-equation (new-eq base-eq &optional condition-name)
  (let* ((new-eq-real (if (listp new-eq) (first new-eq) new-eq))
	 (new-gp-mark (when (listp new-eq) (cdr new-eq)))
	 (new-piece 
	  (append new-gp-mark
		  (if condition-name
		      (add-condition (cdr (equation-variable new-eq-real)) 
				     (equation-rhs new-eq-real) condition-name)
		      (copy-tree (equation-rhs new-eq-real)))))
	 (base-eq-rhs (equation-rhs base-eq))
	 (base-eq-marked (listp (car base-eq-rhs)))
	 (operator (if base-eq-marked (cadr base-eq-rhs) (car base-eq-rhs)))
	 (aggregator (variable?-aggregator (cdr (equation-variable new-eq-real)))))
    (if (eq operator 'equation-aggregator)
	;; aggregator exists, so we just tack the new piece onto the
	;; end.  note: although CLISP defines a setf form for IF,
	;; other Lisps do not.  so we make the type splitting
	;; explicit.
	(if (differential-equation-p base-eq)
	    (setf (diff-eq-rhs base-eq) (append base-eq-rhs 
						(list new-piece)))
	    (setf (alg-eq-rhs base-eq) (append base-eq-rhs 
					       (list new-piece))))
	(let ((agg-fn
	       (cond ((eq aggregator 'sum) #'+)
		     ((eq aggregator 'prod) #'*)
		     ((eq aggregator 'min) #'min)
		     ((eq aggregator 'max) #'max))))
	  (if (differential-equation-p base-eq)
	      (setf (diff-eq-rhs base-eq) 
		    `(equation-aggregator ,agg-fn ,base-eq-rhs ,new-piece))
	      (setf (alg-eq-rhs base-eq) 
		    `(equation-aggregator ,agg-fn ,base-eq-rhs ,new-piece))))))
  base-eq)  

;;;;;;;;;;;;;;;;;;;;;;;; END COMBINE EQUATIONS ;;;;;;;;;;;;;;;;;;;;;;;
