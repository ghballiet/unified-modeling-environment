(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MODEL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;; A SC-IPM process model. A flat combination of process instances.
;;;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Checked 10/22/2007

;; A sc-ipm process model struct.
;;
;; The fields are as follows.
;; name: a string specifying the name of the model
;; entities: a list of instantiated entities in the model
;; processes: the list of the processes in the model, these should be 
;;            process instances, not generic processes
;; comment: a string specifying a user's comments on the model.
(defstruct model
  (name nil)
  (entities nil)
  (processes nil)
  (comment nil))

;; example/ (note that none of the constants have assigned values)
;;
;; model: MODEL-0
;;   entities:
;;     aurelia{producer}:
;;     nasutum{grazer}:
;;       attack_rate = NIL
;;       gcap = NIL
;;       gmax = NIL
;;       assim_eff = NIL
;;     ratio-dependent-2(P:{aurelia}, G:{nasutum})
;;       h = NIL
;;     grazing(P:{aurelia}, G:{nasutum})
;;     exponential-loss(G:{nasutum})
;;       loss_rate = NIL
;;     logistic-growth(P:{aurelia})
;;       growth_rate = NIL
;;       saturation = NIL
(defun print-model (m &optional (stream t))
  (let ((out-string ""))
    (setf out-string
	  (concatenate 'string out-string 
		       (format nil "model: ~A~%  entities:~%" (model-name m))))
    (dolist (e (model-entities m))
      (setf out-string
	    (concatenate 'string out-string (format nil "~,,4@A:~%" e)))
      (when (entity-constants e)
	(dolist (c (hash-table-vals (entity-constants e)))
	  (setf out-string
		(concatenate 'string out-string 
			     (format nil "~,,6@A~%" 
				     (print-constant? c nil)))))))
    (dolist (p (model-processes m))
      (setf out-string
	    (concatenate 'string out-string (format nil "~,,4@A~%" p)))
      (when (process-constants p)
	(dolist (c (hash-table-vals (process-constants p)))
	  (setf out-string
		(concatenate 'string out-string 
			     (format nil "~,,6@A~%" 
				     (print-constant? c nil)))))))
    (format stream "~A" out-string)))
    

;; INPUT
;;    a model
;; OUTPUT
;;   returns all the entity variables in the model as 
;;   (entity . variable) conses
(defun get-entity-variables (model)
  "Returns the variables associated with entities in a model."
  (let ((var-lst))
    (dolist (e (model-entities model) var-lst)
      (when (entity-variables e)
	(maphash #'(lambda (k v)
		     (declare (ignore k))
		     (push (cons e v) var-lst))
		 (entity-variables e))))))

;; INPUT
;;    a model
;; OUTPUT
;;   returns all the entity constants in the model as
;;   (entity . constant) conses
(defun get-entity-constants (model)
  "Returns the constants associated with entities in a model."
  (let ((const-lst))
    (dolist (e (model-entities model) const-lst)
      (when (entity-constants e)
	(maphash #'(lambda (k v)
		     (declare (ignore k))
		     (push (cons e v) const-lst))
		 (entity-constants e))))))

;; INPUT
;;    a model 
;; OUTPUT
;;   returns a list of all the variables in the model as
;;   (entity/process . variable) conses
(defun get-variables (model)
  "Returns all the variables in a model."
  (let ((ev (get-entity-variables model))
	(pv (flatten (mapcar #'(lambda (p) (get-process-variables p)) (model-processes model)))))
    ;; make sure nils are not surreptitiously added
    (cond ((and ev pv) (append ev pv))
	  (ev ev)
	  (pv pv))))

;; INPUT
;;    a model 
;; OUTPUT
;;   returns a list of all the constants in the model as
;;   (entity/process . constant) conses
(defun get-constants (model)
  "Returns all the constants in a model."
  (let ((ec (get-entity-constants model))
	(pc (flatten (mapcar #'(lambda (p) (get-process-constants p)) 
			     (model-processes model)))))
    ;; make sure nils are not surreptitiously added
    (cond ((and ec pc) (append ec pc))
	  (ec ec)
	  (pc pc))))

;; INPUT
;;    a model
;; OUTPUT
;;   returns a list of the exogenous variables
;;   stored as (entity/process . variable) conses
(defun get-exogenous-variables (model)
  "Returns a model's exogenous variables."
  (delete-if-not #'(lambda (x)
		     (variable?-exogenous (cdr x)))
		 (get-variables model)))

;; INPUT
;;   a model
;; OUTPUT
;;   returns a list of the nonexogenous variables stored as
;;   (entity/process . variable) conses
;;
;; SC-IPM OK (I think, needs more testing)
(defun get-nonexogenous-variables (model)
  "Returns the nonexogenous variables in a model."
  (delete-if #'(lambda (x)
		 (variable?-exogenous (cdr x)))
	     (get-variables model)))

;; INPUT
;;    a model
;; OUTPUT
;;   returns a list of the observed variables stored as
;;   (entity/process . variable) conses
(defun get-observed-variables (model)
  "Returns the nonexogenous variables associated with a data trajectory."
  (delete-if-not #'(lambda (x)
		     (and 
		      (not (variable?-exogenous (cdr x)))
		      (variable?-data-name (cdr x))))
		 (get-variables model)))

;; INPUT
;;    a model
;; OUTPUT
;;   returns a list of the unobserved variables stored as
;;   (entity/process . variable) conses
(defun get-unobserved-variables (model)
  "Returns the variables not associated with a data trajectory."
  (delete-if #'(lambda (x)
		 (variable?-data-name (cdr x)))
	     (get-variables model)))


;; INPUT
;;    a model
;; OUTPUT
;;   returns all the parameters as (entity/process . constant) conses
;;   separated into three lists
;;     (1) constants
;;     (2) initial conditions for hidden variables
;;     (3) initial conditions for observed variables
(defun get-parameters (model)
  (list (get-constants model)
	(get-unobserved-variables model)
	(get-observed-variables model)))
