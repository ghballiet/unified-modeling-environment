(in-package :scipm)

;(defpackage "GENERATOR"
;  (:use "COMMON-LISP")
;  (:export "GET-GENERATOR" "RANDOM-STRUCTURE"))

;(in-package generator)

;;;;;;;;;;;;;;;;;;;;;;;;
;;; EXPORTED SYMBOLS
;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;
;; get-generator
;;
;; input: a list of instanted entities and a generic process library
;; output: a model structure generator
(defun get-generator (entities library &key cnf?)
  (initialize-generator (make-structure-generator
			 :entities entities
			 :library library)
			cnf?))


;;;;;;;;;;;;;;;;;;;;;;;
;; andor-structure
;;
;; input: a structure generator and an optional model index that
;;        will be part of the model's name.  the default index is 0.
;; output: an interned model named model-<idx> or nil
;;
;; NOTE:
;; the constraints may make it possible for a valid model to have 0
;; processes, but this function will return nil instead.  the
;; assumption is that a model must have at least one process.
(defun andor-structure (sg &key (idx 0))
  (let ((processes (select-processes-random (sg-logic sg) (sg-processes sg))))
    (when processes
      (make-model
       :name (intern (format nil "MODEL-~A" idx))
       :entities (sg-entities sg)
       :processes processes))))

;;;;;;;;;;;;;;;;;;;;;;;
;; walksat-structure
;;
;; input: a structure generator and an optional model index that
;;        will be part of the model's name.  the default index is 0.
;; output: an interned model named model-<idx> or nil
;;
;; NOTE:
;; the constraints may make it possible for a valid model to have 0
;; processes, but this function will return nil instead.  the
;; assumption is that a model must have at least one process.
(defun walksat-structure (sg &key (idx 0) (reinit t))
  ;; initialize walksat storage for a new problem if requested
  (when reinit
    (ws-initprob (+ (length (sg-processes sg)) 
		    (length (sg-tseitin-vars sg))
		    -1) ;; to correct for the additional nil in sg-processes
		 (sg-logic sg)))

  (let ((processes (select-processes-walksat (sg-logic sg) (sg-processes sg))))
    (when processes
      (make-model
       :name (intern (format nil "MODEL-~A" idx))
       :entities (sg-entities sg)
       :processes processes))))

;;;;; XXX: TO BE COMPLETED
(defun dpll-structure (sg &key (idx 0))
  (declare (ignore sg idx)))

;;;;;;;;;;;;;;;;;;;;;;
;;; HIDDEN SYMBOLS
;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; structure-generator
;;
;; this struct stores the context for a specific structure generator.
;; the core context is defined by two fields:
;;
;; entities: a list of all entity instances to consider
;; library: the library of generic processes, generic entities, and 
;;          constraints that defines the space of models
;;
;; the contents of other fields derive from these two and store 
;; computed structures that are useful for the generation functions
;;
;; processes: a list of all possible instantiations of the
;;            generic processes in the library
;; gp-table: a table with a generic process as the key
;;           and a list of all possible instantiations
;;           (given the ei-list) of the generic process
;; logic: the propositional logic form of the library constraints
;;        the format is internal for use with WalkSAT and similar code
;; tseitin-vars: variables introduced when applying the Tseitin
;;               transformation to cast "logic" in CNF
;;
;; These fields are not currently used
;; cur-assignment: the current cnf assignment that we are
;;                 working with
;; solutions: table of all the solutions that have been generated
;;            thus far.
(defstruct (structure-generator (:conc-name sg- ) (:print-object print-sg))
  (processes nil)
  (entities nil)
  (gp-table (make-hash-table :test #'equal))
  (cur-assignment nil)  ;; not currently used?
  (solutions nil)       ;; not currently used?
  (library nil)
  (logic nil)
  (tseitin-vars nil))

;; print function of the solution generator, primarily for debugging, will
;; need to be reworked at some point

;; newer version as original formatted poorly w/SBCL
;; (and SBCL seems to have issues with following the pretty print protocols :-(
#+SBCL
(defun print-sg (p stream)
  (let ((iTable '()))
    (maphash #'(lambda (k v) (push (list k v) iTable))(sg-gp-table p))
    (format stream "Solution Generator:~%")
    (format stream "~2@TEntity Instances:~%~{~4@T~S~%~}" (sg-entities p))
    (format stream "~%~2@TProcess Instances:~%~{~4@T~S~%~}" (sg-processes p))
    (format stream "~%~2TGP -> Indices:~%~:{~4T~S~&~6T-> ~A~%~}" iTable)
    (format stream "~%  Solutions:~%    ~S~%" (sg-solutions p))))

;; original function
#-SBCL
(defun print-sg (p stream)
  (let ((iTable '()))
    (maphash #'(lambda (k v) (push (list k v) iTable))(sg-gp-table p))
    (format stream "Solution Generator:~_")
    (format stream "  Entity Instance:~S~_" (sg-entities p))
    (format stream "  Process Instances:~_   ~S~_" (sg-processes p))
    (format stream "  GP -> Indices:~_~:{   ~S:~A~_~}" iTable)
    (format stream "  Solutions: ~S~_" (sg-solutions p))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; reused-entities
;;
;; input: 
;;   p: a process instance
;;
;; output: 
;;   true if an entity instance is used in multiple entity roles.
(defun reused-entities (p)
  (let ((filtered (remove-duplicates (hash-table-vals (process-entities p)) :test #'equal)))
    (> (length (hash-table-vals (process-entities p))) (length filtered))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; filter-odd-processes
;;
;; input:
;;   plst: a list of process instances
;;
;; output:
;;   the process list with sketchy instances removed.
;;
;; these are cases that we would want to remove even if there aren't
;; any constraints against them.
(defun filter-odd-processes (plst)
  (remove-if #'reused-entities plst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; initialize-generator
;;
;; input: 
;;   sg: a structure generator that has an associated list of entities
;;       and a library
;; output:
;;   sg: computes the values of the other fields based on the entities
;;       and library and returns the structure
;;
;; Fills in the solution generator structure with instance information.
;; Goes through each generic process in the library and instantiates it in 
;; all possible ways. Adds a list of indices into sets containing the 
;; at the beginning of each gp-list in the sets hash table
;; to indicate where the instances are.
(defun initialize-generator (sg cnf?)    

  ;; store the available process instances and associate them with
  ;; their generic processes.  note that we could remove the processes
  ;; field and simply get the values of the gp-table when necessary, but
  ;; we may want to capitalize on the ordering of the processes.
  (let (instances)
    (dolist (gp (lib-processes (sg-library sg)))
      (setf instances (filter-odd-processes (all-instances gp (sg-entities sg))))
      (setf (sg-processes sg) (append (sg-processes sg) instances))
      (setf (gethash gp (sg-gp-table sg)) instances)))

  ;; this is a carry-over from the walksat limitations (index started at 1).
  ;; consider reworking the code so that this isn't necessary.
  (push nil (sg-processes sg))

  ;; construct the logical formulation of the constraints within this
  ;; structure-generator context.  replace the processes with indices
  ;; in the generators process list.  this lets us store presence and
  ;; absence of processes in an array.
  (setf (sg-logic sg)
	(if cnf?
	    (clause-to-walksat
	     (logic-object-to-index
	      (cons 'and 
		    (mappend #'(lambda (c) 
				 (multiple-value-bind (l v) (constraint-to-logic c sg t)
				   ;; store any auxilliary variables
				   (when v 
				     (setf (sg-tseitin-vars sg)
					   (append v (sg-tseitin-vars sg))))
				   ;; each of the implemented constraints
				   ;; begins with an AND to signify a
				   ;; conjunction strip this off so that we
				   ;; have a true AND/OR tree
				   (cdr l)))
			     (lib-constraints (sg-library sg))))
	      (append (sg-processes sg) (sg-tseitin-vars sg))))
	    ;; NNF for simple and/or tree search
	    (logic-object-to-index
	     (cons 'and 
		   (mappend #'(lambda (c) 
				(cdr (constraint-to-logic c sg nil)))
			    (lib-constraints (sg-library sg))))
	     (sg-processes sg))))
  sg)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; constraint-to-logic
;;
;; input:
;;   c: a constraint
;;   sg: a structure generator
;; output:
;;   returns the logical formulation of the constraint within the 
;;   context of the particular structure generator.
;;   if the conversion introduces auxiliary variables, those are
;;   returned as a second value
(defun constraint-to-logic (c sg cnf?)
  (let ((type (constraint-type c)))
    (cond ((eq 'always-together type)
	   (if cnf?
	       (always-together-to-cnf (always-together-logic c sg))
	       (always-together-logic c sg)))
	  ((eq 'at-most-one type)
	   (if cnf?
	       (xor-to-cnf (at-most-one-logic c sg))
	       (at-most-one-logic c sg)))
	  ((eq 'exactly-one type)
	   (if cnf?
	       (xor-to-cnf (exactly-one-logic c sg))
	       (exactly-one-logic c sg)))
	  ((eq 'necessary type)
	   (necessary-logic c sg)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; logic-object-to-index
;;
;; input: 
;;   slogic - logic sentence with operators in the 0th slot and 
;;            either a list, a symbol, or a process in the other slots
;;   object-list - a list of objects
;;
;; note: the equivalence test is #'eq
;;
;; output:
;;   returns a sentence with the same structure as slogic, but 
;;   the objects are replaced by their index within object list
(defun logic-object-to-index (slogic object-list)
  ;; retain the operator
  (cons (first slogic)
	(mapcar #'(lambda (x)
		    (cond ((or (process-p x) (atom x))
			   (position x object-list :test #'eq))
			  ((listp x)
			   (logic-object-to-index x object-list))))
		(rest slogic))))


;;;;;;;;;;;;;;;;;;;;;
;;;  SEARCH CODE
;;;;;;;;;;;;;;;;;;;;;

;; (aref assignment 0) is a dummy for the walksat code
(defun array-to-processes (assignment process-list)
  (loop 
     for idx from 1 upto (array-dimension assignment 0) 
     and process in (rest process-list)
     when (= (aref assignment idx) 1)
     collect process))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Random WalkSAT search
;;;
;;; Here SC-IPM's logic is in conjunctive normal form, which lets us
;;; use various methods for SAT solving.  The basic, random solution
;;; approach uses WalkSAT.  A later all-SAT approach will employ DPLL.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; select-processes-walksat
;;
;; preconditions: expects WalkSAT memory to be initialized
;; 
;; input:
;;   logic - constraints to be satisfied
;;   process-list - available instantiated processes
;;   cutoff - (keyword) number of attempts to satisfy the constraints
;;              before reporting failure
;;   target - (keyword) number of false clauses allowed
;;
;; output:
;;   if a satisfying assignment occurs, the corresponding list of instantiated processes
;;   nil otherwise
(defun select-processes-walksat (logic process-list &key (target 0) (cutoff 10000))
  (declare (ignore logic))
  ;; randomize the variables
  (map-into atoms #'(lambda () (random 2)))
  
  ;; determine the number of true literals in each clause
  (ws-init)

  ;; wander through the main loop
  (while (and (> numfalse target) (< numflip cutoff))
    (incf numflip)
    (ws-flipatom (ws-pickbest)))

  ;; return a valid assignment if one exists
  (if (< numflip cutoff)
      (array-to-processes atoms process-list)
      nil))

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Random AND/OR Search
;;;
;;; Here SC-IPM's logic is in negation normal form, which lets us
;;; treat the sentence as an AND/OR tree.  By making selections
;;; (either in order or at random) for the OR branches, we can create
;;; a single conjunct that determines the values of a subset of the
;;; variables (i.e., determines whether a process instance appears in
;;; the model). One can set those variables that don't appear in the
;;; final conjunction arbitrarily.
;;;
;;; By treating the constraint satisfaction problem as a form of
;;; AND/OR tree search, we make a critical assumption. To avoid
;;; excessive backtracking, most AND trees must be consistent (i.e.,
;;; they cannot include A and not-A). This assumption holds if the
;;; constraints all refer to separate generic processes. When multiple
;;; constraints control the expression of one generic process, then
;;; backtracking may be required.  However, we expect this to occur
;;; rarely, and believe that this presents a more feasible solution
;;; than conversion to CNF or DNF which is known to be problematic
;;; even for simple process libraries.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; select-processes-random
;;
;; input:
;;   logic - constraints to be satisfied
;;   process-list - available instantiated processes
;;   attempts - (keyword) number of attempts to satisfy the constraints
;;              before reporting failure
;; output:
;;   if a satisfying assignment occurs, the corresponding list of instantiated processes
;;   nil otherwise
(defun select-processes-random (logic process-list &key (attempts 100))
  (let ((assignment (make-array (length process-list)))
	(success))
    (while (and (not success) (>= (decf attempts) 0)) 
      (fill-vector nil assignment)
      (setf success (satisfy-constraints-random logic assignment)))
    (when success
      (array-to-processes (randomize-free-variables assignment) process-list))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; randomize-free-variables
;;
;; input:
;;   arr - a one-dimensional array where each index is the 
;;         index of a process and the value is 1 if the process
;;         appears in a model, 0 if it doesn't, and nil if it's
;;         free
;; output (destructive):
;;   randomly assigns free variables in arr to 0 or 1 and returns
;;   the updated array
(defun randomize-free-variables (arr)
  (let ((array-size (array-dimension arr 0)))
    (loop for idx from 0 below array-size do
	 (unless (aref arr idx)
	   (setf (aref arr idx) (random 2))))
    arr))

;; systematically walk through all the assignments of the 
;; free variables.  we should introduce a mechanism for 
;; recognizing previously visited structures.  we should 
;; introduce a 'get-next-structure' function that is the 
;; main interface to the search code.  that would keep the
;; counting mechanism in this function encapsulated within
;; a small set of other functions.
;;; THIS FUNCTION IS UNREFERENCED
(defun set-free-variables (arr) (declare (ignore arr)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; satisfy-constraints-random
;;
;; input: 
;;   logic - a logical sentence from a structure generator
;;   arr - a one-dimensional array where each index is the 
;;         index of a process and the value is 1 if the process
;;         appears in a model, 0 if it doesn't, and nil if it's
;;         free
;;
;; output (destructive):
;;   arr - if the array was modified to satisfy a constraint
;;   nil - if a satisfying assignment could not be made
;;
;; fills arr with a satisfying assignment of all the variables.
;; does not maintain state, so each satisfying assignment is 
;; generated independently from any others.
;; satisfaction is handled randomly, so each subsequent run will
;; likely produce a different model.
;;
;; do not use this function for systematic search.
;; this is a very naive approach that may take a long time to 
;; find a single solution.  it's slightly more sensible than 
;; randomly generating a bit vector and testing against the 
;; constraints, but not by much.
(defun satisfy-constraints-random (logic arr)
  (cond ((integerp logic)
	 ;; handle individual processes.
	 (cond ((null (aref arr logic)) (setf (aref arr logic) 1) arr)
	       ((= (aref arr logic) 1) arr)
	       (t nil)))
	((eq (car logic) 'not)
	 ;; handle negated individual processes.
	 (cond ((null (aref arr (second logic))) (setf (aref arr (second logic)) 0) arr)
	       ((= (aref arr (second logic)) 0) arr)
	       (t nil)))
	((eq (car logic) 'and)
	 ;; handle conjuncts by satisfying all of them.
	 ;; any failure here leads to a total failure up the stack.
	 (unless (member nil 
			 (mapcar #'(lambda (cjt) 
				     (satisfy-constraints-random cjt arr))
				 (rest logic)))
	   arr))
	((eq (car logic) 'or)
	 ;; fails if all of its parts fail. propagate the failure up the stack.
	 ;; we don't worry about backtracking here, so randomly select a 
	 ;; disjunct to satisfy and give it a try.  if it doesn't work, then
	 ;; the whole sequence of calls will fail.
	 #-NOT-LINEAR
	 ;; with only one level of ... well kind of, backtracking ...
	 ;; save arrays for disjuncts which are ok, and randomly choosing one
	 ;; and updating the arr values with it.
	 (let (arr-set)
	   (loop for disjunct
	      in (rest logic)
	      do (let ((arr-copy (copy-vector arr)))
		   (when (satisfy-constraints-random disjunct arr-copy)
		     (push arr-copy arr-set))))
	   (when arr-set
	     (format T "DISJ arr-set: ~A~%" (length arr-set))
	     (let ((arr-copy-random (nth (random (length arr-set)) arr-set)))
	       (loop for x from 0 to (1- (length arr-copy-random))
		  do (setf (aref arr x) (aref arr-copy-random x))))
	     arr))
	 #+NOT-LINEAR
	 (let ((cjt-idx (+ 1 (random (length (rest logic))))))
	   (when (satisfy-constraints-random (nth cjt-idx logic) arr)
	     arr)))))

