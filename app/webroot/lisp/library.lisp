(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LIBRARY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 
;;;;; Contains the library structure used to store generic processes, generic
;;;;; entities, and constraints.
;;;;; 
;;;;; Includes functions that instantiate generic processes and enable selective
;;;;; retrieval of processes.
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Checked 10/23/2007

;;;; STRUCT: library ;;;;
;;
;; FIELDS
;;   processes: a list of all generic-process structs in the libaray, 
;;              to be used during the structural search
;;   entities: a list of generic-entity structs, to be used during the 
;;             structural search
;;   constraints: a list of process-set structs, which groups generic processes
;;                with constraints

;; ONLY FOR USE BY RERUN
(defvar *generic-library-version* NIL)

(defstruct (library (:conc-name lib-))
  (name nil)
  (version nil)
  (modified nil)
  (processes nil)
  (entities nil)
  (constraints nil))

(defun generic-library-modified (library) (lib-modified library))

(defun generic-library-version (library) (lib-version library))
(defun set-generic-library-version (library version)
  (setf (lib-version library) version))
(defsetf generic-library-version set-generic-library-version)
  
;;;; FUNCTION: all-instances ;;;;
;;
;; INPUT
;;   ei-list: a list of lists containing entity instances, if 
;;            this is nil then this is considered that no 
;;            constraints are given and all  possible entity 
;;            instance sets, according to each entity-role are 
;;            returned if the meet the cardinality checks.
;;   a-generic-process: as stated, a generic process struct
;; OUTPUT
;;   list-of-lists(a list containing lists of instances).  Contains possible sets 
;;   of entity instances that can be used in instances of the generic-process
;;   or NIL if the generic process cannot satisfy the constraints.
;; DESCRIPTION: This function checks that the generic process argument can 
;;              relate the instances passed in (ei-list).  It does this by
;;              checking that the cardinality of the set of mutal instances
;;              between each constraint and entity-role.
(defun all-instances (a-generic-process ei-list)
  ;; get a list of lists, containing the possible entity instances that this 
  ;; process can relate
  (let* ((relates-list 
	  (mapcar #'(lambda (e-role-cons);the generic entity that this process relates
		      (let* ((e-role (cdr e-role-cons))
			     (instance-list (get-entity-instance-list 
					     (entity-role-types e-role)
					     ei-list)))
			instance-list))		
		  (gp-entity-roles a-generic-process)))
	 (ret-list nil)
	 (item-index (make-list (length relates-list) :initial-element 0)))
    (loop 
     (push (new-process a-generic-process (index-to-list item-index relates-list))
	   ret-list)
     (unless (increment-index-list item-index relates-list)
       (return ret-list)))))

;;;; FUNCTION: new-process ;;;;
;;
;; returns a process instance of g-process type which relates
;; the entities in the relates-instances-list
(defun new-process (g-process relates-instances-list)	
  (let ((e-roles (gp-entity-roles g-process))
	(e-hash (make-hash-table :test #'equal))
	(c-hash (make-hash-table :test #'equal))
	(c-types (gp-constants g-process)))
    ;; bind entity instances to local names, e-roles and relates
    ;; must be the same length
    (mapc #'(lambda (x y)
	      (setf (gethash (car x) e-hash) (list y))) e-roles relates-instances-list)
    
    ;; copy constants
    (when c-types
      (maphash #'(lambda (k v)
		   (setf (gethash k c-hash)
			 (make-constant? 
			  :type v
			  :initial-value nil)))
	       c-types))
    (make-process
     :name (gp-name g-process)
     :generic-process g-process
     :entities e-hash
     :constants c-hash
     ;; XXX: process level variables are not supported properly
     #+NO-VARIABLES-IN-PROCESSES
     :variables
     #+NO-VARIABLES-IN-PROCESSES (gp-variables g-process))))


;;;; FUNCTION: get-generic-processes named ;;;;
;;
;; INPUT
;; lib: the library to search through
;; name: the name of the generic process to look for
;;
;; OUTPUT
;; a generic processes which has the same name
;; as the argument
;; 
;; RAB - "library-processes" -> "lib-processes"
(defun get-generic-processes-named (lib name)
  (find-if #'(lambda (x) (equal (gp-name x) name)) (lib-processes lib)))


;;;; FUNCTION: get-generic-processes-of-type ;;;;
;;
;; INPUT
;; lib: the library to search through
;; type: the name of the generic process to look for
;;
;; OUTPUT
;; a generic processes which have their type equal
;; to the 'type' argument
;; RAB - "library-processes" -> "lib-processes"
;; RAB - undefined function "gp-type" so commenting out def'n for now

;;; (defun get-generic-processes-of-type (lib type)
;;;   (remove-if-not #'(lambda (x) (equal (gp-type x) type)) (lib-processes lib)))


;;;; FUNCTION: get-entity-instance-list ;;;;
;;
;; INPUT
;; generic-entity-list: list of generic entities that we want all instances of
;; entity-list: entity instances to match against the generic entity list
;;
;; OUTPUT
;; a list of entities that instantiate a generic entity in the given list
(defun get-entity-instance-list (generic-entity-list entity-list)
  (intersection entity-list generic-entity-list
		:test #'(lambda (ie ge)
			  (eq (entity-generic-entity ie) ge))))
;;;  note: the eq should be adequate in this case
;			  (string-equal
;			   (generic-entity-type (entity-generic-entity ie))
;			   (generic-entity-type ge)))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The following processes are unused as of 10/23/07
;;; They were written to support process sets, but these have since been
;;; replaced by flattened constraints.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; takes a list of number and return a list of list containing 
;; what corresponds to a set of SAT clauses where a assignement
;; gives only one process
;(defun gen-mutex-list (var-set)
;  (let ((ret-list nil)
;	(exclusive-list (mapcar #'(lambda (x) (list x x)) var-set))
;	(index-list (make-list (length var-set) :initial-element 0)))
    ;; handle length one explictly
;    (if (equal 1 (length var-set))
;	   (list var-set)
;	  (progn
;	    (loop
;	     (if (or (= 0 (num-Ones index-list)) (> (num-Ones index-list) 1))
;		 (push (get-negated-clause var-set index-list)  ret-list))
;	     (unless (increment-index-list index-list exclusive-list)
;	       (return ret-list)))))))

;;return the number of 1's in the list of numbers
;(defun num-Ones (lst)
;  (let ((sum 0))
;    (mapc #'(lambda (x) (setf sum (+ sum x))) lst)
;    sum))

;; signs is a list of 1's and 0's
;; var-set is a list of numbers
;(defun get-negated-clause (var-set signs)
;  (mapcar #'(lambda (v s) 
;	      (if (equal s 1)
;		(- v)
;		v)) var-set signs))
    
;; returns a list of gp names in the constraint set of name
;(defun processes-in-set-named (name lib)
;  (let (lst)
;    (dolist (cur-set (library-sets lib) lst)
;      (when (equal (process-set-name cur-set) name)
;	(return (mapcar #'(lambda (x) (gp-name x)) (process-set-generic-processes cur-set)))))))


;; checks if the string p corresponds to the name of a set
;(defun is-set-name (p lib)
;  (let ((name-list (mapcar #'(lambda (s) (process-set-name s)) (library-sets lib))))
;    (intersection (list p) name-list :test 'equal)))

;; checks if the string corresponds to some genric process in the library
;(defun is-gp-name (p lib)
;  (let ((name-list (mapcar #'(lambda (x) (gp-name x)) (library-processes lib))))
;    (intersection (list p) name-list :test 'equal)))


       
;; we need to make sure that the models dont
;; duplicate models
;(defun get-model (lib)
;  (CNF-to-model lib (walksat (- (length (library-pi-list lib)) 1) 
;			     (library-cnf lib))))

;; try to get a new model if we fail after 1000
;; tries, give up
;(defun get-new-model (lib)
;  (let ((solution))
;    (dotimes (i 100)
;      (setf solution (walksat (- (length (library-pi-list lib)) 1) 
;			      (library-cnf lib)))
;      (when (is-new-solution solution lib)

;(defun 
;; returns a list of process instances, corresponding to a process model
;(defun CNF-to-model (lib solution)
;  (format t "~S~%" solution)
;  (remove nil (mapcar #'(lambda (n) 
;	      (if (> (aref solution n) 0)
;		  (nth n (library-pi-list lib))
;		  nil)) (range-n-m 1 (- (length (library-pi-list lib)) 1)))))
