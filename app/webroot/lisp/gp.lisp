
(in-package :scipm)

;;;; GP.LISP ;;;;
;;;;;;;;;;;;;;;;;;;;;;

;;; This file contains the structures used to represent a generic process
;;; library, instantiated processes and entities, and models.
;;;
;;; modified to account for changes based in cb-ipm

(defmethod print-to-save (x &optional (stream t))
  (format stream "~S" x))

(defmethod print-to-save ((x hash-table) &optional (stream t))
  (format stream "(let ((hash-table (make-hash-table)))")
  (maphash #'(lambda (key value)
	       (format stream "~%   (setf (gethash ~S hash-table)" key)
	       (format stream "~%      ")
	       (print-to-save value stream))
	   x)
  (format stream ")~%"))

(defmethod print-to-save ((x list) &optional (stream T))
  (format stream "(")
  (loop for item in x do (format stream "~% ") (print-to-save item stream))
  (format stream ")"))

;; A generic process contains the following fields.
;; name: a string specifying the name of the process

;; constants: a map of local constant-types that are used by the process
;; variables: a map of local variable-types that are used by the process
;; conditions: a list of the Boolean conditions that must be met to activate
;;             the process
;; entity-roles: an assoc-list of the entity-roles available in this process.
;; (we use an assoc-list for the convenience of assoc.  we could also use a 
;;  regular list and query the er for its name each time as well.)
;; equations: a list of differential and algebraic equations in this process
;; comment: a string containing user comments about this generic process
(defstruct (generic-process (:conc-name gp- ) (:print-object print-gp))
  (name nil)
  (conditions nil)
  (constants nil)
;  (variables nil)     <=  NO VARIABLES IN PROCESSES - conv w/Will 18May11
  (equations nil)
  (entity-roles nil)
  (comment nil))

;; orginal didn't work well with SBCL "pretty printer".
;; Also, changed the equations print as it is a list of equations, so print each one iteratively.

#+SBCL
(defun print-gp (p stream)
  
  (format stream 
	  "GENERIC-PROCESS ~A[~A]:~%~
                                  ~18Tconditions ~A~%~
                                  ~18Tconstants ~A~%~
                                  ~18Tequations ~{~A~%~}"
	  (gp-name p)
	  (mapcar #'cdr (gp-entity-roles p))
	  (gp-conditions p)
	  (gp-constants p)
;	  (gp-variables p)
	  (gp-equations p)))

;; the original of above.
#-SBCL
(defun print-gp (p stream)
  (format stream 
	  "generic-process ~A[~A]:~%~Tconditions ~A~%~Tconstants ~A~%~Tequations ~A"
	  (gp-name p)
	  (mapcar #'cdr (gp-entity-roles p))
	  (gp-conditions p)
	  (gp-constants p)
;	  (gp-variables p)
	  (gp-equations p)))

;; a constant-type refers to a storage place for values that do not change
;; during the execution of the model.  As a result, constant-types cannot 
;; occur on the left hand side of an equation.
;;
;; The fields are as follows.
;; name: a string specifying the name of the constant
;; upper-bound, lower-bound: numeric bounds on the value of the constant for 
;;                           use during automated parameter-estimation.
;; units: a string specifying the dimensions of the constant if any exist
;; comment: a string containing the user's comments about this parameter
(defstruct constant-type
  (name nil)
  (upper-bound nil)
  (lower-bound nil)
  (comment nil)
  (units nil))

;; a variable-type refers to a storage place for a value that may change
;; as the model executes.  
;;
;; The fields are as follows.
;; name: a string specifying the name of the variable
;; upper-bound, lower-bound: numeric bounds on the initial value of the 
;;                           variable for use during automated parameter
;;                           estimation.
;; units: a string indicating the dimensions of the variable.
;; aggregators: a list of functions that indicate how this variable should
;;              be aggregated if it appears on the left hand side of multiple
;;              equations.  (sum, prod, min, max)
;; comment: a string specifying a user's comments on this variable.
(defstruct variable-type
  (name nil)
  (upper-bound nil)
  (lower-bound nil)
  (units nil)
  (comment nil)
  (aggregators nil))


;; an entity-role determines the type of entities that can participate
;; in a particular process
;; 
;; The fields are as follows.
;; name: a string specifying the name of this entity role within the process.
;; types: a list of the types of entities that can fill this role, this is 
;;        a list of generic entities..
(defstruct (entity-role (:print-object print-erole))
  (name nil)
  (types nil))

(defun print-erole (p stream)
  (format stream "~A[~A]" (entity-role-name p) 
	  (mapcar #'generic-entity-type (entity-role-types p))))

;; a generic-entity collects a set of properties into a bundle that can 
;; be passed through the model intact.
;;
;; The fields are as follows.
;; type: a string specifying the type-name for this collection of properties
;; variables: a list of variable-types contained in this entity type.
;; constants: a list of constant-types contained in this entity type.
;; comment: a string containing the user's comments on this entity type.
(defstruct generic-entity ;(generic-entity  (:print-object print-ge) )
  (type nil) 
  (variables nil)
  (constants nil)
  (comment nil))

(defun print-ge (p stream)
  (format stream "~S" (generic-entity-type p)))
    
(defun ge-equal (arg1 arg2)
  (string-equal (generic-entity-type arg1) (generic-entity-type arg2)))

;; a differential-equation
;;
;; The fields are as follows.
;; variable: the variable-type (in a generic process) or the variable (in an
;;           instantiated process) that has its rate defined by the associated
;;           equation.  In dx/dt, this is the x.
;; respect-to: the variable-type (or variable) that the differentiation is
;;             taken with respect to.  In dx/dt, this is the t.
;; order: an integer specifying the order of the differential equation.
;; rhs: the right hand side of the equation
(defstruct (differential-equation (:conc-name diff-eq-) (:print-object print-ode))
  (variable nil)
  (respect-to nil)
  (order 1)
  (rhs nil))

(defun print-ode (p stream)
  (format stream "d[~A,~A,~A] =~%"
	  (diff-eq-variable p)
	  (or (diff-eq-respect-to p) "time")
	  (diff-eq-order p))
  (print-diff-eq-rhs (diff-eq-rhs p) stream))

(defun print-diff-eq-rhs (rhs stream &optional (spaces "   "))
  (format stream "~A~A" 
	  spaces
	  (remove nil 
		  (loop for element in rhs collect (cond 
						     ((eql element 'EQUATION-AGGREGATOR) nil)
						     ((eql element #'+) "+")
						     ((eql element #'*) "*")
						     ((eql element #'min) "MIN")
						     ((eql element #'max) "MAX")
						     (T element))))))

					 
;; an algebraic equation
;;
;; The fields are as follows.
;; variable: the variable-type (in a generic process) or the variable (in an
;;           instantiated process) that is defined by the associated equation.
;; rhs: the right hand side of the equation.
(defstruct (algebraic-equation (:conc-name alg-eq-) (:print-object print-ae))
  (variable nil)
  (rhs nil))

(defun print-ae (p stream)
  (format stream "~A = ~A"
	  (alg-eq-variable p)
	  (alg-eq-rhs p)))

;; an instantiated process
;;
;; The fields are as follows.
;; name: a string specifying the name of this process
;; generic-process: the generic process from which this process derives
;; variables: a list of process-specific local variables
;; constants: a list of process-specific local constants
;; (both variables and constants should be deep copies of the types from
;;  the generic process)
;; entities: a map of each entity role to the list of entities that fill it.
;; equations: a list of expanded and instantiated equations from the generic 
;;            process.  if two entities fill the same role, then the 
;;            equations should be expanded accordingly.
;; conditions: a list of expanded and instantiated conditions from the
;;             generic process.  similar to equations.
;; comment: a string specifying a user's comments

;; RAB sez --
;; sb-ext::process-p exists in the common-lisp-user package. Shadowing it allow for the
;; process defstruct to create a process-p type w/o interfering with the sb-ext package.

#+sbcl (eval-when (:compile-toplevel :load-toplevel :execute) (shadow 'process-p))

(defstruct (process (:print-object print-pi) )
  (name nil)
  (generic-process nil)
  (variables nil)
  (constants nil)
  (entities nil)
  (comment nil))

(defmethod print-to-save ((p process) &optional (stream t))
  (format stream "#S(PROCESS")
  (loop for (slot-name slot-accessor)
     in '((:name process-name)
	  (:generic-process process-generic-process)
	  (:variables process-variables)
	  (:constants process-constants)
	  (:entities process-entities)
	  (:comment process-comment))
     do (progn (format stream "~%    ~S " slot-name)
	       (print-to-save (funcall slot-accessor p) stream)))
  (format stream ")~%"))

(defun process-entity-roles (process)
  (let ((ents))
    (maphash #'(lambda (role e-list) 
		 (push (list role e-list) ents)) 
	     (process-entities process))
    ents))

(defun print-pi (p stream)
  ;; e.g., process-name(erole1:{p1 p2 p3}, erole2:{g1})
  (let (out-string
	first-er
	first-e
	(ents (process-entity-roles p)))
    (setf out-string (format nil "~A(" (process-name p)))
    (setf first-er t)
    (dolist (er ents)
      (setf first-e t)
      ;; role name
      (setf out-string (format nil "~A~A~A:{" out-string
			       (if first-er 
				   (progn (setf first-er nil) "")
				   ", ")
			       (car er)))
      (dolist (e (second er))
	;; entities assigned to role
	(setf out-string (format nil "~A~A~A" out-string 
				 (if first-e
				     (progn (setf first-e nil) "")
				     " ")
				 (entity-name e))))
      (setf out-string (format nil "~A}" out-string)))
    (format stream "~A)" out-string)))

;; an instantiated entity
;;
;; The fields are as follows.
;; name: a string specifying the name of the entity within the model
;; generic-entity: the entity type to which this entity conforms
;; variables: a list of entity-specific variables
;; constants: a list of entity-specific constants.
;; comment: a string specifying the user's comments.
(defstruct (entity (:print-object print-entity))
  (name nil)
  (generic-entity nil)
  (variables nil)
  (constants nil)
  (comment nil))

(defun print-entity (e stream)
  (format stream "~A{~A}" 
	  (entity-name e)
	  (generic-entity-type (entity-generic-entity e))))

(defmethod print-to-save ((e entity) &optional (stream T))
  (format stream "#S(ENTITY")
  (loop for (slot-name slot-accessor)
     in '((:name entity-name)
	  (:generic-entity entity-generic-entity)
	  (:variables entity-variables)
	  (:constants entity-constants)
	  (:comment entity-comment))
     do (progn (format stream "~%    ~S " slot-name)
	       (print-to-save (funcall slot-accessor e) stream)))
  (format stream ")"))

;; an instantiated variable
;;
;; changes will have to be made to the variable type when we support
;; process-level variables.
;;
;; The fields are as follows.
;; type: a variable type
;; initial-value: a number specifying an initial value for the variablec
;;                if the variable is not observed.
;; upper-bound, lower-bound: numeric bounds on the initial value of the 
;;                           variable for use during automated parameter
;;                           estimation.
;; data-name: a string indicating the variable's name in a data file if that
;;            variable is observed.  A value here overrides values specified
;;            for the initial-value.
;; units: a string indicating the dimensions of the variable.
;; exogenous: true when this variable only serves as input to the model
;;            exogenous variables must be read from a data file at all 
;;            time points
;; comment: a string specifying a user's comments on this variable.
(defstruct (variable? (:print-object print-variable?))
  (type nil)
  (initial-value nil)
  (upper-bound nil)
  (lower-bound nil)
  (comment nil)
  (units nil)
  (data-name nil)
  (exogenous nil)
  (aggregator 'sum))

(defun print-variable? (v &optional (stream t))
  (format stream "~A" (variable-type-name (variable?-type v))))

(defmethod print-to-save ((v variable?) &optional (stream t))
  (format stream "#S(VARIABLE?")
  (loop for (slot-name slot-accessor)
     in '((:type variable?-type)
	  (:initial-value variable?-initial-value)
	  (:upper-bound variable?-upper-bound)
	  (:lower-bound variable?-lower-bound)
	  (:comment variable?-comment)
	  (:units variable?-units)
	  (:data-name variable?-data-name)
	  (:exogenous variable?-exogenous)
	  (:aggregator variable?-aggregator))
     do (progn (format stream "~%    ~S " slot-name)
	       (print-to-save (funcall slot-accessor v) stream)))
  (format stream ")~%"))

;; an instantiated constant
;;
;; instantiated constants can override the fields of their types
;;
;; The fields are as follows.
;; name: a string specifying the name of the constant
;; initial-value: a number specifying a preset value of the constant
;; upper-bound, lower-bound: numeric bounds on the value of the constant for 
;;                           use during automated parameter-estimation.
;; units: a string specifying the dimensions of the constant if any exist
;; comment: a string containing the user's comments about this parameter
(defstruct (constant? (:print-object print-constant?))
  (type nil)
  (initial-value nil)
  (upper-bound nil)
  (lower-bound nil)
  (comment nil)
  (units nil))

(defun print-constant? (c &optional (stream t))
  (format stream "~A = ~F" 
	  (constant-type-name (constant?-type c))
	  (constant?-initial-value c)))

(defmethod print-to-save ((c constant?) &optional (stream T))
  (format stream "#S(CONSTANT?")
  (loop for (slot-name slot-accessor)
     in '((:type constant?-type)
	  (:initial-value constant?-initial-value)
	  (:upper-bound constant?-upper-bound)
	  (:lower-bound constant?-lower-bound)
	  (:comment constant?-comment)
	  (:units constant?-units))
     do (progn (format stream "~%    ~S " slot-name)
	       (print-to-save (funcall slot-accessor c) stream)))
  (format stream ")~%"))

;;; functions to decrease the pain of building these structures ;;;

;; input
;; type: entity type name
;; variables: a list of variable types (optional)
;; constants: a list of constant types (optional)
;; comment: a comment (optional)
;;
;; output
;; a generic entity associated with the stored information
;;
;; this method takes care of storing the variables and constants
;; into hash tables as specified in the structure definition.
(defun create-generic-entity
  (&key type variables constants comment)
  (declare (ignore comment))
  (let ((vhash) (chash))
    (when variables
      (setf vhash (make-hash-table :test #'equal))
      (dolist (v variables)
	(setf (gethash (variable-type-name v) vhash) v)))
    (when constants
      (setf chash (make-hash-table :test #'equal))
      (dolist (c constants)
	(setf (gethash (constant-type-name c) chash) c)))
    (make-generic-entity
     :type type
     :variables vhash
     :constants chash)))

;; input
;; name: generic process name
;; type: generic process type
;; variables: a list of variable types (optional)
;; constants: a list of constant types (optional)
;; equations: a list of algebraic/differential equations (optional)
;; conditions: a list of boolean conditions (optional)
;; entity-roles: the entity roles
;; comment: a comment (optional)
;;
;; output
;; a generic process associated with the stored information
;;
;; this method takes care of storing the variables and constants
;; into hash tables and the entity roles into assoc-lists as the
;; specification requires.
(defun create-generic-process
  (&key name type constants equations conditions entity-roles comment)
  (declare (ignore type comment))
  (let ((chash) (erlist))
    (when constants
      (setf chash (make-hash-table :test #'equal))
      (dolist (c constants)
	(setf (gethash (constant-type-name c) chash) c)))
    (dolist (e entity-roles)
      (push (cons (entity-role-name e) e) erlist))

    (make-generic-process
     :name name
     :conditions conditions
     :equations equations
     :constants chash
     :entity-roles erlist)))



;;; macros and functions to decrease the pain of accessing these
;;; structures ;;;

;; takes an algebraic or differential equation and returns an accessor
;; to the variable on the LHS of the equation
(defmacro equation-variable (eq)
  `(cond ((differential-equation-p ,eq)
	  (diff-eq-variable ,eq))
	 ((algebraic-equation-p ,eq)
	  (alg-eq-variable ,eq))
	 (t
	  nil)))

;; takes an algebraic or differential equation and returns an accessor
;; to the RHS of the equation
(defmacro equation-rhs (eq)
  `(cond ((differential-equation-p ,eq)
	  (diff-eq-rhs ,eq))
	 ((algebraic-equation-p ,eq)
	  (alg-eq-rhs ,eq))
	 (t
	  nil)))

;; given a process
;;
;; return a list of the entity instances this process relates
(defun get-process-entity-instances (p)
  (when p (hash-table-vals (process-entities p))))

;; given a process
;;
;; return non-nil if the process does in fact relate the
;; entity instance ent
(defun check-relates-entity (p ent)
  (intersection (list ent) (hash-table-vals (process-entities p))))

;; given a process
;;
;; returns the variables of this process 
;; (process . variable) conses
;;
;; SC-IPM OK
(defun get-process-variables (p)
  (let ((var-lst))
    ;; grab local variables
    (if (process-variables p)
	(setf var-lst
	      (mapcar #'(lambda (x)
			  (cons p x))
		      (hash-table-vals (process-variables p)))))
      (delete-if #'null var-lst)))

;; given a process
;;
;; returns the constants of this process and all subprocesses as
;; (process . constant) conses
;;
;; SC-IPM OK
(defun get-process-constants (p)
  (let ((const-lst))
    ;; grab local constants
    (if (process-constants p)
	(setf const-lst
	      (mapcar #'(lambda (x)
			  (cons p x))
		      (hash-table-vals (process-constants p)))))
      (delete-if #'null const-lst)))

;;; variables must have a name, an initial value, and an aggregator in that order
;;; variables may have a fourth item that is the string variable name
;;; variables may have a fifth item that, when true, states that the variable is exogenous
;;; constants must have a name and an initial value in that order
;;; data name and exogenous are optional here
(defun create-entity (name ge &key (variables nil) (constants nil) (comment nil))
  (let (vhash chash)
    (when variables
      (setf vhash (make-hash-table :test #'equal))
      (mapc #'(lambda (x) 
	       (setf (gethash (first x) vhash)
		     (make-variable? 
		      :type (gethash (first x) (generic-entity-variables ge))
		      :initial-value (second x)
		      :aggregator (third x)
		      :data-name (fourth x) ;; nil is the default for data-name
		      :exogenous (fifth x)))) ;; nil is the default for exogenous
	   variables))
    (when constants
      (setf chash (make-hash-table :test #'equal))
      (mapc #'(lambda (x) 
	       (setf (gethash (first x) chash)
		     (make-constant?
		      :type (gethash (first x) (generic-entity-constants ge))
		      :initial-value (second x))))
	   constants))
    (make-entity 
     :name name
     :generic-entity ge
     :variables vhash
     :constants chash
     :comment comment)))

;(create-entity "det" detritus 
;	       :variables '(("conc" 0.1152038846719937d0 'sum))
;	       :constants '(("remin_rate" 0.0391272d0) ("sinking_rate" 0.0994564d0)))



(defun create-process (name gp &key (entities nil)
		       #+NO-VARIABLES-IN-PROCESSES (variables nil) 
		       (constants nil) (comment nil))
  (let (#+NO-VARIABLES-IN-PROCESSES vhash chash ehash)
    (when entities
      (setf ehash (make-hash-table :test #'equal))
      (mapc #'(lambda (x)
	       (setf (gethash (first x) ehash)
		     (mapcar #'symbol-value (rest x))))
	   entities))
    #+NO-VARIABLES-IN-PROCESSES
    (when variables
      (setf vhash (make-hash-table :test #'equal))
      (mapc #'(lambda (x) 
	       (setf (gethash (first x) vhash)
		     (make-variable? 
		      :type (gethash (first x) (gp-variables gp))
		      :initial-value (second x)
		      :aggregator (third x)
		      :data-name (fourth x) ;; nil is the default for data-name
		      :exogenous (fifth x)))) ;; nil is the default for exogenous
	   variables))
    (when constants
      (setf chash (make-hash-table :test #'equal))
      (mapc #'(lambda (x) 
	       (setf (gethash (first x) chash)
		     (make-constant?
		      :type (gethash (first x) (gp-constants gp))
		      :initial-value (second x))))
	   constants))
    (make-process
     :name name
     :generic-process gp
     :entities ehash
;     :variables vhash
     :constants chash
     :comment comment)))
