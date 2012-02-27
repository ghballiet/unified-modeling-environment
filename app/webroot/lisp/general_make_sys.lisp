(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;; MAKE SYS GENERAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;; The functions in this file help build the model functions that
;;;;; the chosen simulator calls to evaluate a system of equations.
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#+THREADED-SCIPM
(declaim (special *exogenous-variables* *model-constants* *current-data-set*)
	 (type (simple-array double-float *) *exogenous-variables* *model-constants*))

;;;; FOR NOT-THREADED-SCIPM
;;;; this closure stores arrays that specify an order for:
;;;;
;;;; * algebraic variables
;;;; * system (differential) variables
;;;; * exogenous variables
;;;; * model constants
;;;;
;;;; a mapping from the stored property to an array index is also kept
#-THREADED-SCIPM
(let ((alg-array)
      (sys-array)
      (exo-array)
      (const-array)
      (var-idx-map (make-hash-table :test #'equal)))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; build-var-structures
  ;;;
  ;;; this function creates an order for properties of a modeled
  ;;; system.  the order can be shared between Lisp and C, and it
  ;;; indicates a location in a vector where the program temporarily
  ;;; stores the property's value.
  ;;;
  ;;; this function must be given both a model and a list of equations
  ;;; paired with their conditions as returned by build-equations.
  ;;;
  ;;; the map between properties and their indices makes the link:
  ;;; (X . property) --> (3 . ALG)
  (defun build-var-structures (model lst)
    (let ((var-lsts  (separate-variables model lst)))
      (setf alg-array (apply #'vector (first var-lsts))
            sys-array (apply #'vector (second var-lsts))
            exo-array (apply #'vector (third var-lsts))
            const-array (apply #'vector (get-constants model)))
    (labels ((addvars (arr tag)
	       (dotimes (i (length arr))
		 (setf (gethash (#+clisp svref #-clisp aref arr i)
			var-idx-map)
		       (cons i tag)))))

      (addvars alg-array 'ALG)
      (addvars sys-array 'SYS)
      (addvars exo-array 'EXO)
      (addvars const-array 'CON))))

  ;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; get-var-idx-map
  ;;;
  ;;; this function returns the map between properties and their
  ;;; locations in the various property arrays.
  (defun get-var-idx-map ()
    var-idx-map)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; getv-algebraic-variables
  ;;; 
  ;;; this function returns an ordered vector of algebraic variables
  (defun getv-algebraic-variables ()
    alg-array)  
  
  ;;;;;;;;;;;;;;;;;;;;;;;
  ;;; getv-constants
  ;;; 
  ;;; this function returns an ordered vector of constants
  (defun getv-constants ()
    const-array)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; getv-system-variables
  ;;; 
  ;;; this function returns an ordered vector of system variables
  (defun getv-system-variables ()
    sys-array)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; getv-exogenous-variables
  ;;; 
  ;;; this function returns an ordered vector of exogenous variables
  (defun getv-exogenous-variables ()
    exo-array))


;;;; this set of functions stores arrays that specify an order for:
;;;;
;;;; * algebraic variables
;;;; * system (differential) variables
;;;; * exogenous variables
;;;; * model constants
;;;;
;;;; a mapping from the stored property to an array index is also kept

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; build-var-structures
;;;
;;; this function creates an order for properties of a modeled
;;; system.  the order can be shared between Lisp and C, and it
;;; indicates a location in a vector where the program temporarily
;;; stores the property's value.
;;;
;;; this function must be given both a model and a list of equations
;;; paired with their conditions as returned by build-equations.
;;;
;;; the map between properties and their indices makes the link:
;;; (X . property) --> (3 . ALG)
#+THREADED-SCIPM
(defun build-var-structures (model lst)
  (declare (special alg-array sys-array exo-array const-array var-idx-map))
  (let ((var-lsts  (separate-variables model lst)))
    (setf alg-array (apply #'vector (first var-lsts))
	  sys-array (apply #'vector (second var-lsts))
	  exo-array (apply #'vector (third var-lsts))
	  const-array (apply #'vector (get-constants model)))
    (labels ((addvars (arr tag)
	       (dotimes (i (length arr))
		 (setf (gethash (#+clisp svref #-clisp aref arr i)
				var-idx-map)
		       (cons i tag)))))

      (addvars alg-array 'ALG)
      (addvars sys-array 'SYS)
      (addvars exo-array 'EXO)
      (addvars const-array 'CON))))

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-var-idx-map
;;;
;;; this function returns the map between properties and their
;;; locations in the various property arrays.
#+THREADED-SCIPM
(defun get-var-idx-map ()
  (declare (special var-idx-map))
  var-idx-map)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; getv-algebraic-variables
;;; 
;;; this function returns an ordered vector of algebraic variables
#+THREADED-SCIPM
(defun getv-algebraic-variables ()
  (declare (special alg-array))
  alg-array)
  
;;;;;;;;;;;;;;;;;;;;;;;
;;; getv-constants
;;; 
;;; this function returns an ordered vector of constants
#+THREADED-SCIPM
(defun getv-constants ()
  (declare (special const-array))
  const-array)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; getv-system-variables
;;; 
;;; this function returns an ordered vector of system variables
#+THREADED-SCIPM
(defun getv-system-variables ()
  (declare (special sys-array))
  sys-array)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; getv-exogenous-variables
;;; 
;;; this function returns an ordered vector of exogenous variables
#+THREADED-SCIPM
(defun getv-exogenous-variables ()
  (declare (special exo-array))
  exo-array)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-variable-lists
;;;
;;; this function returns a list of three lists
;;;
;;; * algebraic variables
;;; * system variables
;;; * exogenous variables
;;;
;;; where the elements are ordered by their associated indices in the
;;; temporary storage array used by the simulated model.
(defun get-variable-lists ()
  (list (vector-to-list (getv-algebraic-variables))
	(vector-to-list (getv-system-variables))
	(vector-to-list (getv-exogenous-variables))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fill-model-constants
;;;
;;; this function stores the values of the constants into the
;;; *model-constants* array.  if the constants have nil values, then
;;; they are initialized to zero.
(defun fill-model-constants ()
  (let ((consts (getv-constants)))
    (dotimes (i (length consts))
      (setf 
       #+clisp (svref *model-constants* i)
       #-clisp (aref *model-constants* i)
       (let ((const-val (constant?-initial-value (cdr 
						  #+clisp (svref consts i)
						  #-clisp (aref consts i)
						  ))))
	 (if const-val
	     const-val
	     0d0))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; assign-exo-vars
;;;
;;; this function returns a list of setf statements that updates the
;;; values of the *exogenous-variables* vector according to the
;;; current simulation time and the *current-data-set*.  it expects a
;;; vector of exogenous variables and the name of the variable that
;;; stores the current simulation time.
(defun assign-exo-vars (xarr t-name)
  (if (> (length xarr) 0)
      (let ((exolst))
	(list 
	 (append `(let ((current-t-index (t-to-index ,t-name *current-data-set*))))
		 (dotimes (i (length xarr) exolst)
		   (push
		    `(setf 
		      #+clisp (svref *exogenous-variables* ,i)
		      #-clisp (aref *exogenous-variables* ,i)
		      (coerce (datum-value (datum *current-data-set* current-t-index)
					   (quote ,(read-from-string (variable?-data-name 
								      (cdr 
								       #+clisp (svref xarr i)
								       #-clisp (aref xarr i)
								       ))))
					   *current-data-set*) 'double-float))
		    exolst)))))
      ;; '((declare (ignore time)))
      ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; extract-variables
;;;
;;; this function takes an equation represented as a Lisp s-expression
;;; and returns a list of the variables referenced in the equation.
(defun extract-variables (eqrhs &optional (ht (make-hash-table :test #'equal)))
  ;; variables are conses that have a variable? as the cdr
  ;; walk through the tree and return a flat list of those things
  (cond ((null eqrhs) nil)
	((atom eqrhs) nil)
	((variable?-p (cdr eqrhs))
	 (setf (gethash eqrhs ht) t))
	(t
	 (extract-variables (car eqrhs) ht)
	 (extract-variables (cdr eqrhs) ht)))
  ht)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; order-algebraic-equations
;;;
;;; this function orders a list of algebraic equations so that
;;; variables are assigned values before they are used.
;;;
;;; CAVEAT: the equations actually come out of here in reversed order
;;; so that "push" will place them in the correct causal order.
;;;
;;; ASSUME: a valid ordering exists otherwise you get an infinite loop
;;;         this needs to be fixed eventually
(defun order-algebraic-equations (alg-lst)
  (when alg-lst
    (let ((vars (get-variable-lists))
	  (all-vars)  ;; all the variables in the set of equations
	  (calc-vars) ;; the variables whose values can be considered "calculated"
	  (ordered-eqs 0) ;; the number of ordered algebraic equations
	  (new-order)) ;; the new order of the algebraic equations
      (setf all-vars (apply #'append vars))
      (setf calc-vars (append (second vars) (third vars)))
      (while (and (< (length calc-vars) (length all-vars))
		  (< ordered-eqs (length alg-lst)))
	(dolist (eq alg-lst)
	  (unless (member eq new-order)
	    ;; make sure all the variables have been calculated in previous equations
	    ;; if they haven't then continue
	    ;; if they have, then append this equation to the list, up
	    ;; the ordered-eqs count, and add the LHS variable to
	    ;; calc-vars
	    (unless (set-difference (hash-table-keys (extract-variables (alg-eq-rhs eq)))
				    calc-vars :test #'equal)
	      (push eq new-order)
	      (incf ordered-eqs)
	      (push (alg-eq-variable eq) calc-vars)))))
      new-order)))
