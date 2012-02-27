(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;; LOGIC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 
;;;;; The code below contains the translation of each constraint into
;;;;; its logical form, it mixes both the functionality of the solution
;;;;; generator and the process set.
;;;;;
;;;;; assumes that each item in a constraint is a generic process.
;;;;;
;;;;; the general structure returned from each of the logic creation
;;;;; functions should be a valid AND/OR tree with a conjunction at
;;;;; the root (even if there is only one subtree below it).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(in-package generator)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; NECESSARY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
;; necessary-logic
;;
;; transforms a necessary constraint (p-set) into propositional CNF
;; form that indicates which instantiated processes must occur in a
;; model.
;; 
;; the resulting structure has the form:
;; (AND (OR pia1 pia2 pia3) (OR pib1)...)
(defun necessary-logic (c sg)
  (cons 'and 
	(loop for disjunct 
	   in (nec-modify
	       c
	       ;; each sublist is a disjunct of the instantiations 
	       ;; of a particular generic process
	       (mapcar #'(lambda (cm)
			   (gethash (conmod-gprocess cm) (sg-gp-table sg)))
		       (constraint-items c))
	       (all-item-syms c))
	   ;; flatten single-item lists, otherwise build a formal disjunct
	   collect (if (cdr disjunct)
		       (cons 'or disjunct)
		       (car disjunct)))))

;;;;;;;;;;;;;;;;;
;; nec-modify
;;
;; this function ensures that the necessary constraint, when modified
;; by an entity role, is expanded correctly.
;;
;; example: necessary X grazing(X,_)
;; would indicate that an instantiation of grazing is required for
;; each entity that can fill the role of X in the generic process.
;; 
;; input: the current constraint, a
;; CNF clause that is not modified by any symbol, and a list of
;; symbols that modify the constraint.
;;
;; output: a conjunctive list of lists, where the sublists indicate a 
;; logical disjunction of the contained processes.
(defun nec-modify (c logic syms)
  ;; if there are no symbols that affect the constraint, then we're done
  (if (null syms)
      logic
      ;; split disjuncts apart if the processes are modified by one of the symbols
      ;; use recursion to loop through the list of symbols and modify the sentence
      (nec-modify 
       c 
       (mappend #'(lambda (or-cls)
		    (split-disjunct 
		     or-cls
		     ;; this function gives the entity role
		     ;; that is constrained by the current symbol
		     ;; if it exists
		     (is-constrained-by 
		      c 
		      (process-generic-process (first or-cls))
		      (first syms))))
		logic)
       (rest syms))))

;;;;;;;;;;;;;;;;;
;; split-disjunct
;; 
;; given a list of processes that share the same generic process, 
;; return a list of lists of processes where the processes in 
;; each sublist share the same entity for the specified entity role
(defun split-disjunct (or-cls ent-role)
  (if (null ent-role)
      (list or-cls)
    ;; create a list of processes that have the same entity filling
    ;; the given entity role -- k: entity; v: list of processes
    (let ((ht (make-hash-table)))
      (dolist (p or-cls (hash-table-vals ht))
	;; remember that roles are bound to a list containing a single
	;; instantiated entity -- this is a holdover from when one could
	;; bind multiple entities to a single role.
	(push p (gethash (car (gethash ent-role (process-entities p))) ht))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; AT MOST ONE and EXACTLY ONE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;
;; exactly-one-logic
;;
;; mutal exclusion where the null assignment will not satisy
;; if a, b, and c are mutually exclusive, this will yield
;; (AND (OR (AND a (NOT b) (NOT c))
;;          (AND (NOT a) b (NOT c))
;;          (AND (NOT a) (NOT b) c)))
(defun exactly-one-logic (c sg)
  (at-most-one-logic c sg nil))


;;;;;;;;;;;;;;;;;;;;
;; at-most-one-logic
;;
;; mutual exclusion where the null assignment will also satisfy
;; yields logic similar to that for exactly-one-logic, but includes
;; the case (AND (NOT a) (NOT b) (NOT c)) in the list of conjuncts
(defun at-most-one-logic (c sg &optional (count-null t))
  ;; create the conjunct of clauses that capture mutual exclusion
  (build-mutex-logic
   (amo-modify c 
	       ;; each sublist from the mapping is a disjunct of the 
	       ;; instantiations of a particular generic process.
	       (list (amo-disjuncts (constraint-items c) sg))
	       (all-item-syms c))
   count-null))

(defun amo-disjuncts (ci sg)
  (remove-duplicates (mappend #'(lambda (cm)
				  (gethash (conmod-gprocess cm) (sg-gp-table sg)))
			      ci)
		     :test #'equal))

;;;;;;;;;;;;;;;;;
;; amo-modify
;;
;; this function ensures that the at-most-one constraint, when modified
;; by an entity role, is expanded correctly.
;;
;; example: at-most-one X grazing(X,_)
;; would indicate that one instantiation of grazing can occur for
;; each entity that can fill the role of X in the generic process.
;; 
;; input: the current constraint, the solution-generator context, a
;; list of mutually exclusive process instances, and a list of
;; symbols that modify the constraint.
;;
;; output: a list of lists that contain mutually exclusive process sets
(defun amo-modify (c mutex-lst syms)
  ;; if there are no symbols that affect the constraint, then we're done
  (if (null syms)
      mutex-lst
    ;; create sublists that reflect mutually exclusive process sets
    (amo-modify c 
		(mappend #'(lambda (mutex-cls) (split-mutex (first syms) mutex-cls c))
			 mutex-lst)
		(rest syms))))

;;;;;;;;;;;;;;;;;;
;; split-mutex
;;
;; takes a list of mutually exclusive processes and a symbol that modifies
;; the constraint.  splits the list mutually exclusive processes based on
;; the modifier.
;;
;; e.g. ( A{X1} A{X2} B{Y1} C{X1} C{X2} ) and X which modifies the role
;; filled by X1 and X2 in A and C
;;
;; returns ( (A{X1} B{Y1} C{X1}) (A{X2} B{Y1} C{X2}) )
(defun split-mutex (sym mutex-cls c)
  (if (null sym)
      (list mutex-cls)
    ;; create a list of processes that have the same entity filling
    ;; the given entity role -- k: entity or 'none; v: list of processes
    (let ((ht (make-hash-table)))
      (dolist (p mutex-cls (build-mutex-lsts ht))
	(let ((ent-role (is-constrained-by c (process-generic-process p) sym)))
	  (if ent-role
	      ;; remember that roles are bound to a list containing a single
	      ;; instantiated entity -- this is a holdover from when one could
	      ;; bind multiple entities to a single role.
	      (push p (gethash (car (gethash ent-role (process-entities p))) ht))
	    (push p (gethash 'none ht))))))))

;; spreads the processes that were not bound by a modifier across
;; all the mutually exclusive lists
(defun build-mutex-lsts (ht)
  (let ((ubiq (gethash 'none ht)))
    (if (null ubiq)
	(hash-table-vals ht)
      (remove-if #'null
		 (loop for k being the hash-keys of ht using (hash-value v)
		       collect (unless (eq k 'none)
				 (append v ubiq)))))))

;; expands a list of mutually exclusive item lists and adds the 
;; appropriate logical connectives.  if count-null is true, then
;; the resulting logic represents "at most one" otherwise it 
;; represents "exactly one"
(defun build-mutex-logic (mutex-lsts count-null)
  (cons 'and
	(mapcar #'(lambda (mlst) 
		    (cons 'or 
			  (if count-null
			      ;; "upto" will push the counter beyond the end 
			      ;; of the list, so mutex-pos will return the 
			      ;; conjunct with all variables negated
			      (loop for idx upto (length mlst)
				    collect (mutex-and (mutex-pos mlst idx)))
			    ;; "below" will work for exactly-one
			    (loop for idx below (length mlst)
				  collect (mutex-and (mutex-pos mlst idx))))))
		mutex-lsts)))

;; lst is a list of processes, each of which may be negated
;; only add an 'and to the beginning of the list if there are
;; multiple processes.  otherwise, just return the single process.
;;
;; changed 9/8/2008: always add an 'and to the beginning of the list.
;; this ensures consistency of the mutex clause structure regardless
;; of list length.
(defun mutex-and (lst)
;;  (if (> (length lst) 1)
      (cons 'and lst))
      ;; (car lst)))

;; given a list of items, negates all but the one at index pos-idx
;; e.g., (A B C D) and 2 gives ( (NOT A) (NOT B) C (NOT D) )
(defun mutex-pos (mlst pos-idx &optional (cur-idx 0))
  (when mlst
    (if (= cur-idx pos-idx)
	(cons (car mlst) (mutex-pos (cdr mlst) pos-idx (+ cur-idx 1)))
      (cons (list 'not (car mlst)) (mutex-pos (cdr mlst) pos-idx (+ cur-idx 1))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ALWAYS TOGETHER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; note: this is the messiest constraint to translate.  the algorithm implemented
;;       below lacks in efficiency and may also lack in comprehensibility.  tests
;;       indicate that it works well, although the constraints produced aren't the 
;;       most elegant and can at times be tautologous.  


;; when unmodified, the logic of an always-together constraint is simple
;; if A and B are generic processes with instances A1, A2, B1, B2, then
;; the resulting logic is
;; (OR A1 A2 B1 B2) --> (AND (OR A1 A2) (B1 B2))
;;
;; when modified, this logic associated with this constraint changes more
;; dramatically than with the other three.
;; e.g.,
;;  generic processes A{X,Y}, B{Y}, and C{X,Y}
;;  entities X1, X2, Y1, Y2
;;  constraint is A{X,_}, B{_}, C{X,_}
;;
;;  the resulting logic is a conjunction of the following three implications
;;  (OR A{X1,Y1} A{X1,Y2} C{X1,Y1} C{X1,Y2}) --> (AND (OR A{X1,Y1} A{X1,Y2}) (OR C{X1,Y1} C{X1,Y2}) (OR B{Y1} B{Y2}))
;;  (OR A{X2,Y1} A{X2,Y2} C{X2,Y1} C{X2,Y2}) --> (AND (OR A{X2,Y1} A{X2,Y2}) (OR C{X2,Y1} C{X2,Y2}) (OR B{Y1} B{Y2}))
;;  (OR B{Y1} B{Y2}) --> (AND (OR A{X1,Y1} A{X1,Y2} A{X2,Y1} A{X2,Y2}) (OR C{X1,Y1} C{X1,Y2} C{X2,Y1} C{X2,Y2}))
;;
;; the justification for this transformation is not obvious.  at some
;; point we should explain why the constraint works out this way.
(defun always-together-logic (c sg)
  (build-at-logic 
   (at-modify c
	      ;; the structure that we're building is composed of 
	      ;; ( a conjunctive list of always-together implications )
	      ;; each implication contains two lists
	      ;; ( ( antecedent ) ( consequent ) )
	      ;; the antecedent and the consequent are formed of lists of
	      ;; instantiated processes
	      ;; ( (A{X1,Y1} A{X1,Y2}...) (B{Y1} B{Y2}) (C{X1,Y1}...) )
	      (mapcar #'(lambda (cm) (gethash (conmod-gprocess cm) 
					      (sg-gp-table sg)))
		      (constraint-items c))
	      (all-item-syms c))))

;; takes a conjunctive list of always-together implications, an always
;; together constraint, a solution context, and a list of modifying symbols
;;
;; returns a conjunctive list of always-together implications as modified 
;; by the given symbols
;;
;; the main structure has four levels of nesting:
;; level 1: ( a conjunctive list of always-together implications )
;; level 2: ( ( antecedent ) ( consequent ) )
;; level 3: ( ( pis of a shared gp) (pis of a shared gp) )
;; level 4: ( A{X1,Y1} A{X1,Y2}... )
(defun at-modify (c clst syms)
  ;; if there are no symbols that affect the constraint, then we're done
  (if (null syms)
      (list (list (apply #'append clst) clst)) 
      (let* ((sym-ht (build-at-table c clst syms))
	     (unmod-lst (set-difference clst (apply #'append (hash-table-vals sym-ht))))
	     (mod-imps (apply #'append 
			      (loop for v being the hash-values of sym-ht using (hash-key k)
				 collect (at-apply-symbol k v (set-difference clst v :test #'equal) c)))))
	(if unmod-lst
	    (cons (list (apply #'append unmod-lst) clst) mod-imps)
	    mod-imps))))
		  

;; returns a hash table where each set of instantiated processes
;; is associated with each symbol that modifies its members.
;;
;; example:
;;   ((A{X1} A{X2}) (B{X1,Y1} B{X1,Y2} B{X2,Y1} B{X2,Y2}))
;;   where A is modified by X and B is modified by X and Y
;;
;; Table: 
;;   X:((A{X1} A{X2}) (B{X1,Y1} B{X1,Y2} B{X2,Y1} B{X2,Y2}))
;;   Y:((B{X1,Y1} B{X1,Y2} B{X2,Y1} B{X2,Y2}))
(defun build-at-table (c clst syms)
  (let ((sym-ht (make-hash-table)))
    (dolist (sym syms sym-ht)
      (dolist (pgrp clst)
	(when (is-constrained-by c (process-generic-process (car pgrp)) sym)
	  (push pgrp (gethash sym sym-ht)))))))


(defun at-apply-symbol (sym mod-lst unmod-lst c)
  (let ((ent-ht (make-hash-table)))
    (dolist (pgrp mod-lst)
      (let ((ent-role (is-constrained-by c
					 (process-generic-process (car pgrp))
					 sym))
	    (grp-ht (make-hash-table)))
	;; group process instances by their instantiated entities for the modified role
	(dolist (p pgrp)
	  (push p (gethash (car (gethash ent-role (process-entities p))) grp-ht)))
	;; build the list of process lists for each instantiated entity across various
	;; generic processes
	(loop for ent-inst being the hash-keys of grp-ht using (hash-value mod-pis)
	   do (push mod-pis (gethash ent-inst ent-ht)))))

    ;; build the implications
    (loop for mod-pis being the hash-values of ent-ht
	 collect (list (apply #'append mod-pis) (append mod-pis unmod-lst)))))


;; turns the nested list structure returned from at-modify into a logical
;; expression of an always-together constraint by adding the logical 
;; operators in the appropriate locations.
(defun build-at-logic (at-lst)
  (cons 'and 
	(mapcar #'(lambda (x) 
		    (list 'or 
			  (at-antecedent (first x))
			  (at-consequent (second x))))
		at-lst)))

;; turns the antecedent represented as a list of process instance lists
;; into a conjunction of negated process instances
;; ((a1 a2 a3) (b1 b2)) --> (AND (NOT a1) (NOT a2) (NOT a3) (NOT b1) (NOT b2))
(defun at-antecedent (lst)
  (cons 'and (mapcar #'(lambda (x) (list 'not x)) lst)))

;; turns the consequent represented as a list of process instance lists
;; into a CNF sentence
;; ((a1 a2 a3) (b1 b2) (c1))) --> (AND (OR a1 a2 a3) (OR b1 b2) c1)
(defun at-consequent (lst)
  (cons 'and
	(mapcar #'(lambda (x) 
		    (if (cdr x)
			(cons 'or x)
		      (car x)))
		lst)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CNF Conversions
;;;
;;; The sentences produced by the always-together and at-most/exactly
;;; one functions are not in CNF, which is a requirement for most
;;; constraint satisfaction solutions.  The following functions carry
;;; out a CNF conversion appropriate to the particular constraints.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;
;; xor-to-cnf
;;
;; a conjunction of mutual-exclusion clauses as produced by 
;; at-most-one-logic or exactly-one-logic
;;
;; Algorithm:
;; 1.  Assign a gensym to each XOR conjunction.
;; 2.  Create a disjunct of those gensyms and add it to the root conjunct.
;; 3.  For each XOR conjunction X, do the following.
;;   a.  For each literal Y in X, do the following.
;;     i.  Create a disjunct of the form (OR (NOT gensym) Y)
;;    ii.  Add this disjunct to the root conjunct.
;;   b.  Create a disjunct that contains X's gensym and the negation of all 
;;       the literals in X.
;;   c.  Add this disjunct to the root conjunct. 
;;
;; A conjunction with N literals will produce N+1 clauses in addition to
;; the modified XOR conjunction created in step 2.  This conversion
;; process is O(N^2) where N is the number of variables involved in the
;; mutual exclusion.  For exactly-one constraints the total number of
;; clauses will be N*(N+1)+1.  For at-most-one constraints, the number will
;; be N*(N+1)+N+2 due to the additional "all false" case.
;;
;; returns two values:
;;  1. the equisatisfiable equivalent to the given formula
;;  2. a list of the auxilliary symbols introduced via term substitution
(defun xor-to-cnf (nnf)
  (let (cnf all-gensyms)
    ;; walk through the mutual exclusive subgroups, which we can treat separately
    (dolist (xor (cdr nnf))
      (let (xor-gensyms)
      ;; walk through the conjunctions for each subgroup
	(dolist (cjt (cdr xor))
	  (cond ((= (length cjt) 2)
		 ;; special case: conjunct with only one variable
		 ;;               don't create an auxilliary
		 (push (second cjt) cnf))
		;; note: consider adding other special cases when 
		;;       or-distribution will lead to fewer clauses
		(t 
		 ;; create an auxilliary variable for the conjunct
		 (let ((x (gensym))
		       (nlst))
		   ;; build the disjunct of auxilliaries
		   (push x xor-gensyms)
		   (push x all-gensyms)
		   ;; build the disjunct for 3b
		   (push x nlst)
		   (dolist (lit (cdr cjt))
		     ;; disjunct for 3a
		     (push (list 'or `(not ,x) lit) cnf)
		     ;; expand the disjunct for 3b with the literals
		     (if (listp lit)
			 (push (second lit) nlst)
			 (push `(not ,lit) nlst)))
		   (push (cons 'or nlst) cnf)))))
	(when xor-gensyms
	  (push (cons 'or xor-gensyms) cnf))))
    (values (cons 'and cnf) all-gensyms)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; always-together-to-cnf
;;
;; the or-distribution rule works fine here.  the antecedent contains
;; only literals and the consequent is already in CNF.  So, we use the
;; following apporach to generate a predictable number of clauses.
;;
;; Algorithm:
;; 1.  For each literal L in the antecedent, do the following.
;;  a.  For each disjunction D in the consequent, do the following.
;;    i.  Add L to D.
;;   ii.  Add this disjunct to the root conjunct.
;;
;; A formula with N literals in the antecedent and M disjunctions in
;; the consequent will produce N*M clauses.  For this constraint, N
;; dominates M, so the total number of new clauses captured only in
;; terms of the size of the antecedent is O(N^2).
(defun always-together-to-cnf (nnf)
  ;; this is slightly complicated by the presence of literals in the
  ;; consequent, although we know that they'll always be positive.
  (let ((cnf))
    ;; ignore the root AND
    (dolist (djt (cdr nnf) (cons 'and cnf))
      ;; walk through the antecedent, ignoring the AND
      ;; cjt will always be negative: (NOT X)
      (dolist (cjt (rest (first (cdr djt))))
	;; walk through the consequent, ignoring the AND
	(dolist (con-djt (rest (second (cdr djt))))
	  ;; identify and strip tautologies in each condition.  due to
	  ;; the structure of this constraint, this step will reduce
	  ;; the clause count by the length of the antecedent
	  (cond ((listp con-djt)
		 ;; strip the 'or, add the new disjunct, then replace the 'or
		 (unless (member (second cjt) (cdr con-djt))
		   (push (cons 'or (cons cjt (cdr con-djt))) cnf)))
		(t
		 ;; con-djt will always be positive, so we don't have to worry about
		 ;; the (NOT X) case.
		 (unless (eq (second cjt) con-djt)
		   (push (list 'or cjt con-djt) cnf)))))))))
