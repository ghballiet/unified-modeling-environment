;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ITEM ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 
;;;;;
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Checked 10/23/2007

;;; An item is the primary building block of process sets.
;;; Items are stored in the items list in the process set structure

;;; An item has a generic process and a list of consistant variables and free 
;;; variables
;;;
;;; in practice this means that is has cons with the name of the entity role 
;;; it would like to be consistant over and an identifier that will be used 
;;; in the set to refer to this consistant variable

;;
;; proc - a generic process
;; vars - an assoc list of the entities to remain consistant over,
;;        the car is the identifer used in the set and the cdr is 
;;        the string representing the entity in the process.
(defstruct item
  (proc nil)
  (vars nil))

;; simple wrapper to remain consistant
(defun create-item (&key proc vars)
  (make-item
   :proc proc
   :vars vars))