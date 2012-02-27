(in-package :scipm)

;;; constraint.lisp (5/08/2008)n

;;; the methods and structures in this file refer to the constraints
;;; on model structures that are associated with a generic process
;;; library.


;;;;;;;;;;;;;;;;;
;; constraint
;;
;; name: the name of the constraint (a symbol not a string)
;; items: a list of generic processes associated with the constraint and
;;        the entity roles that modify it.
;; type: the type of constraint we're using
(defstruct (constraint (:print-object print-constraint))
  name
  type
  items)

;;;;;;;;;;;;;;;;;;;;;;;
;; print-constraint
;;
;; standard print function for the constraint struct
(defun print-constraint (c stream)
    (format stream "Constraint:~A, (type=~S)~_"
	    (constraint-name c)
	    (constraint-type c))
    (format stream "  Items:~{ ~S~}~_"
	    (constraint-items c)))
	
;;;;;;;;;;;;;;;;;;;;;;;;;
;; contains-process
;;
;; c: constraint
;; gproc: generic process to look for in the struct
;;
;; return non-nil if the generic process is in the struct
;; otherwise returns nil
(defun contains-process (c gproc)
  (find gproc (mapcar #'(lambda (cm) (conmod-gprocess cm))
		       (constraint-items c))))

;;;;;;;;;;;;;;;;;;;;;;;;
;; is-constrained-by
;;
;; input:
;;   c: a constraint
;;   gp: a generic process
;;   sym: a symbol that may modify the constraint
;;
;; output: 
;;   when the given process is modified by the symbol in the given constraint
;;     returns the (string) name of the associated entity role
;;   otherwise
;;     returns nil
(defun is-constrained-by (c gp sym)
  (let ((found  
	 (find-if #'(lambda (cm) 
		      (and (eq gp (conmod-gprocess cm)) 
			   (assoc sym (conmod-modifiers cm))))
		  (constraint-items c))))
    (when found
      (cdr (assoc sym (conmod-modifiers found))))))


;;;;;;;;;;;;;;;;;;;;
;; all-item-syms
;;
;; input:
;;   c: a constraint
;; output:
;;   a list of all the symbols within a process set, where each
;;   symbol is associated with an entity role of one or more 
;;   generic processes
(defun all-item-syms (c)
  (let (syms)
    (dolist (item (constraint-items c) (delete-duplicates syms))
      (dolist (var (conmod-modifiers item))
	(push (car var) syms)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; constraint-modifier
;;
;; gprocess: a generic process
;; modifiers: an assoc list of the entities that modify the constraint.
;;            the car is the entity identifer used across the constraint.
;;            the cdr is the string that represents the entity in the process.
(defstruct (constraint-modifier (:conc-name conmod-))
  gprocess
  modifiers)

;; consider removing this
;; simple wrapper to remain consistant
(defun create-conmod (&key gp mods)
  (make-constraint-modifier :gprocess gp :modifiers mods))
