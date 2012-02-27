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
(defun cvode-combine-equations (lst)
  (let ((equations (make-hash-table :test #'equal)))
    ;; walk through each conditions--equations pairing
    (dolist (pair lst)
      (let ((condition (when (car pair)
			 (cons 'and (car pair)))))
	(dolist (eq (cadr pair))
	  (if (gethash (equation-variable eq) equations)
	      (setf (gethash (equation-variable eq) equations)
		    (cvode-aggregate-equation eq 
					      (gethash (equation-variable eq) equations)
					      condition))
	    (setf (gethash (equation-variable eq) equations)
		  (cvode-condition-equation eq condition))))))
    (hash-table-values equations)))

;; given an equation, an associated condition, and a name for that condition
;; 
;; returns a copy of the equation such that if condition is not nil,
;; the RHS of the equation is processed with cvode-add-condition
;;
;; NOTE: the RHS is a deep copy, everything else is shallow.
(defun cvode-condition-equation (eq condition)
  (let ((variable (equation-variable eq))
	(rhs (equation-rhs eq)))
  (if (differential-equation-p eq)
       ;; ASSUME: all equations with the same left hand side
      ;; are taken with respect to the same variable and are
      ;; of the same order
      (make-differential-equation
       :variable variable
       :respect-to (diff-eq-respect-to eq)
       :order (diff-eq-order eq)
       :rhs (if condition
		(cvode-add-condition (cdr variable) rhs condition)
	      (copy-tree rhs)))
    (make-algebraic-equation
     :variable variable
     :rhs (if condition
	      (cvode-add-condition (cdr variable) rhs condition)
	    (copy-tree rhs))))))

;; given a variable, the RHS of an equation, and a condition
;; associated with the equation
;;
;; return the equation wrapped within a statement that tests the given
;; condition.  when the condition is false, a value dependent on the
;; variable's aggregation method is returned. (XXX: NOT YET TRUE)
;;
;; NOTE: the handling of default values assumes the use of aggregation
;; functions that can ignore '().
;; see: cvode-aggregator
(defun cvode-add-condition (var rhs condition)
  (let ((agg (variable?-aggregator var)))
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
(defun cvode-aggregator (fn &rest args)
  (let ((tmp (remove-if #'null args)))
    (if (null tmp)
	0
      (apply fn tmp))))


;; given a differential or algebraic equation, new-eq, and a base
;; equation, base-eq, replace base-eq's RHS with the combination of
;; the RHS's of both base-eq and new-eq.
;;
;; destructive of the base-eq's RHS
;;
;; adds the appropriate conditions unless condition-name is nil
(defun cvode-aggregate-equation (new-eq base-eq &optional condition-name)
  (let ((new-piece 
	 (if condition-name
	     (cvode-add-condition (cdr (equation-variable new-eq)) 
				  (equation-rhs new-eq) condition-name)
	   (copy-tree (equation-rhs new-eq))))
	(operator (car (equation-rhs base-eq)))
	(aggregator (variable?-aggregator (cdr (equation-variable new-eq)))))
    (if (eq operator 'cvode-aggregator)
	;; aggregator exists, so we just tack the new piece onto the end.
	(setf (equation-rhs base-eq) (append (equation-rhs base-eq) 
					     (list new-piece)))
      (let ((agg-fn
	     (cond ((eq aggregator 'sum) #'+)
		   ((eq aggregator 'prod) #'*)
		   ((eq aggregator 'min) #'min)
		   ((eq aggregator 'max) #'max))))
	(setf (equation-rhs base-eq) 
	      `(cvode-aggregator ,agg-fn ,(equation-rhs base-eq) ,new-piece)))))
  base-eq)
  

;;;;;;;;;;;;;;;;;;;;;;;; END COMBINE EQUATIONS ;;;;;;;;;;;;;;;;;;;;;;;