(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;;; BUILD EQUATIONS(sc-ipm) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;; These functions take a model and return a
;;;;; list of condition--equation pairings.  This format is a general
;;;;; intermediate representation that should convert for use by
;;;;; whatever ODE solver is available.
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; build-equations
;;;
;;; creates an intermediate representation of a model as a system of
;;; equations that can then be translated into the necessary format
;;; for a simulation routine.
;;;
;;; at the top level, the function should be given the model.  the
;;; program will ensure that any process-level conditions are included
;;; in the context of the process equations.
;;;
;;; this function will return a list of condition--equation pairings
;;; where a possibly empty list of conditions is followed by a list of
;;; equations that are only evaluated in the context specified by the
;;; conditions.
;;;
;;; ex/ (((cond1 cond2) (eq1 eq2)) ...)
;;;
;;; variables and constants will be represented as dotted lists
;;; (process/entity . variable/constant)
;;;
;;; the constant/variable can be either a constant?/variable? or a
;;; constant-type/variable-type.
;;;
;;; option "with-id" argument appends the generic-process at the end so we 
;;; can recover process contributions to the combined equations for user
;;; analysis
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun build-equations (model &optional (gp-marked-p nil))
  (let (equations)
    (dolist (proc-inst (model-processes model) equations)
      (let* ((generic-process (process-generic-process proc-inst))
	     (generic-equations (gp-equations generic-process)))
	;; generate a list of conditions-equation pairs if necessary
	(when generic-equations
	  (push (append (list 
			 ;; current conditions
			 (mapcar #'(lambda (c)
				     (instantiate-condition c proc-inst))
				 (gp-conditions generic-process))
			 ;; equations
			 (mapcar #'(lambda (q) (instantiate-equation q proc-inst))
				 generic-equations))
			(when gp-marked-p (list proc-inst))) ; (gp-name generic-process))))
		equations))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; instantiate-condition
;;;
;;; instantiates a condition in a given process by replacing the
;;; strings specifying variables/constants in the conditions with the
;;; Lisp objects with which they correspond.
;;;
;;; ASSUMPTION: each entity role maps to a single entity (WHAT???????????)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun instantiate-condition (c p)
  (match-rhs c p))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; instantiate-equation
;;;
;;; instantiates an equation in a given process by replacing the
;;; strings specifying variables/constants in the equations with the
;;; Lisp objects with which they correspond.
;;;
;;; ASSUMPTION: each entity role maps to a single entity
;;;
;;; EXTENSION NOTE: if you want implicit unrolling of equations when
;;; multiple entities play the same role, you'll want to add a
;;; function in here that duplicates the equation appropriately and
;;; unfolds the mapping so that each entity role is associated with a
;;; single entity.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun instantiate-equation (q p)
  ;; match entities and properties to equations
  ;; replace "G.conc" with (foo . conc)
  ;; where foo is an entity and conc is the variable (not just the symbols) 
  ;; create new equations that contain the entities
  ;; and the process level constants/variables.
  (cond 
   ((differential-equation-p q)
    (make-differential-equation
     :order (diff-eq-order q)
     :variable (match-property (diff-eq-variable q) p)
     :respect-to (when (diff-eq-respect-to q)
		   (match-property (diff-eq-respect-to q) p))
     :rhs (match-rhs (diff-eq-rhs q) p)))
    ((algebraic-equation-p q)
     (make-algebraic-equation
      :variable (match-property (alg-eq-variable q) p)
      :rhs (match-rhs (alg-eq-rhs q) p)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; match-property 
;;;
;;; this function matches a string descriptor of a property to the
;;; Lisp representation of that property
;;;
;;; EXTENSION NOTE: implicit unrolling of equations will necessitate a
;;; change to this function as it pulls the list of entity pairings
;;; from the process instead of a list that ensures a 1-to-1
;;; role/entity pairing.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun match-property (v p)
;  (setf *v* v *p* p) 
;  (format T "V = ~S :: P = ~S~%" v p)
  (labels ((split-identifiers (id)
	     ;; given "x.y" returns ("x" "y")
	     ;; given "xy"  returns ("xy")
	     ;; only one "." is assumed, no other structure is attended to.
	     (let ((p (position #\. id)))
	       (if p 
		   (list (subseq id 0 p)
			 (subseq id (+ p 1) (array-total-size id)))
		   (list id)))))
    (let ((vlst (split-identifiers v)))
;      (format t "VLST-~S~%" vlst)
      ;; either we have a local property or an entity property
      (if (= (list-length vlst) 1)
	  ;; local properties won't be qualified (dot-notated)
	  ;; either we have a constant or a variable
	  ;; either the value's defined, or we need to get the
	  ;; constraining information from the generic process
	  (get-local-property (car vlst) p)
	  (let ((ent (car (gethash (car vlst) (process-entities p)))))
	    ;; get the entity first
	    ;; note that the assumption is a one-to-one mapping
	    ;; either we have a constant or a variable
	    (if (and (hash-table-p (entity-constants ent))
		     (gethash (second vlst) (entity-constants ent)))
		(cons ent (gethash (second vlst) (entity-constants ent)))
		(cons ent (gethash (second vlst) (entity-variables ent)))))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-local-property
;;;
;;; this function returns a dotted-pair containing the process and the
;;; property within that process associated with the given name.  the
;;; returned property could be from the instantiated or generic level
;;; of representation.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-local-property (name p)	   
  ;; search for the property in the instantiated process first, and
  ;; if not found, go to the generic process.
  (let ((gp (process-generic-process p)))
    (cons p
	  (cond ((and (process-constants p)
		      (gethash name (process-constants p)))
		 (gethash name (process-constants p)))
		((and (process-variables p)
		      (gethash name (process-variables p)))
		 (gethash name (process-variables p)))
		((and (gp-constants gp)
		      (gethash name (gp-constants gp)))
		 (gethash name (gp-constants gp)))
		#+NO-VARIABLES-IN-PROCESSES
		(t
		 (gethash name (gp-variables gp)))))))
	      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; match-rhs
;;;
;;; this function creates a copy of the expression and replaces the
;;; string descriptors of the properties with the Lisp objects that
;;; represent those properties.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun match-rhs (rhs p)
  (if (atom rhs)
      (if (stringp rhs)
	  (match-property rhs p)
	rhs)
    (cons (match-rhs (car rhs) p)
	  (match-rhs (cdr rhs) p))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; separate-variables
;;;
;;; this function takes a list of condition--equation pairings such as
;;; that returned by build-equations and returns a list that contains
;;; separate lists of algebraic, differential, and exogenous variables
;;; in that order.  the variables are stored as dotted pairs
;;; containing the surrounding entity/process and the variable.
;;; 
;;; note: the lists contain only those variables that are assigned a
;;; value in the model (exogenous and those on the LHS of an equation).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun separate-variables (model cond-eq-pairs)
  ;; keep track of the variables already stored
  (let ((stored (make-hash-table :test #'equal))
	(sys-lst)
	(alg-lst))
    ;; build the lists of algebraic and system variables
    (dolist (p cond-eq-pairs)
      ;; walk through the equations to grab the endogenous variables
      (dolist (eq (cadr p))
	(cond ((differential-equation-p eq)
	       (let ((var (diff-eq-variable eq)))
		 (unless (gethash var stored)
		   (push var sys-lst)
		   (setf (gethash var stored) t))))
	      ((algebraic-equation-p eq)
	       (let ((var (alg-eq-variable eq)))
		 (unless (gethash var stored)
		   (push var alg-lst)
		   (setf (gethash var stored) t)))))))
    ;; build the list of exogenous variables
    ;; and return the results
    (list alg-lst sys-lst (get-exogenous-variables model))))

;;;;;;;;;;;;;;;;;;;;;;;; END BUILD EQUATIONS ;;;;;;;;;;;;;;;;;;;;;;;;
