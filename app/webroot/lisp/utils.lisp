(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; UTILS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 
;;;;; Assorted functions that provide SC-IPM specific functionality.
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Checked 10/24/2007
;;;;; revisit: simplify-sentence, sym-cnf-to-ws-cnf, increment-index-list
				 
;; returns all combinations of the elements in the list, excluding
;; the case where none occur
(defun all-combinations (lst nil-case)
 (let ((index-lst (make-list (length lst) :initial-element 0))
       (ref-lst (mapcar #'(lambda (x) (list nil x)) lst))
       (ret-lst))
   (unless nil-case
     (setf (nth (- (length lst) 1) index-lst)  1))
   (loop
     (push (remove-if #'null (index-to-list index-lst ref-lst)) ret-lst)
     (unless (increment-index-list index-lst ref-lst)
       (return ret-lst)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; trim-clause
;;
;; takes a DNF (CNF) clause in sorted walksat format and removes
;; duplicate variables from individual conjuncts (disjuncts) and
;; removes duplicated conjuncts (disjuncts).
(defun trim-clause (ws-formula)
  (remove-duplicates (mapcar #'remove-duplicates ws-formula) :test #'equal))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; remove-extraneous-clauses
;;
;; strips any tautologous disjuncts from a CNF clause in walksat format
;; 
;; this function will also strip contradictory conjuncts from a DNF clause
(defun remove-extraneous-clauses (ws-formula)
  (loop for cls in ws-formula
	unless (ws-extraneous? cls)
	collect cls))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ws-extraneous?
;; 
;; takes an abs< sorted CNF (DNF) disjunct (conjunct) prepared in
;; walksat form walksat and returns true if it is tautologous
;; (contradictory) (i.e., the disjunct contains a variable and its
;; negation).
(defun ws-extraneous? (ws-clause)
  (loop for atm1 in ws-clause and atm2 in (cdr ws-clause)
	thereis (zerop (+ atm1 atm2))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; abs<
;;
;; takes two numbers: x, y
;; returns:
;;   t if the absolute value of x is less than the absolute value of y
;;   t if the absolute values of x and y are equivalent and x is less than y
;;   nil otherwise.
(defun abs< (x y)
  (if (= (abs x) (abs y))
      (< x y)
    (< (abs x) (abs y))))

;;;;;;;;;;;;;;;;;;;;
;; clause-to-walksat
;;
;; converts a formula from (AND (OR 3 (NOT 3) 4) (OR 4 (NOT 2) 1 9))
;; to ((3 -3 4) (1 -2 4 9))
;;
;; works for clauses in DNF or CNF form and produces a list in the
;; format expected by walksat.
;;
;; the individual conjuncts or disjuncts will be sorted by absolute
;; value
;;
(defun clause-to-walksat (clause)
  (mapcar #'(lambda (c)
	      (if (atom c)
		  (list c)
		  ;; convert each group of variables to walksat form
		  ;; and sort them by absolute value so that we can 
		  ;; quickly detect tautologies.
		  (sort (mapcar #'(lambda (a)
				    (if (atom a)
					a
					(- (second a))))
				(cdr c))
			#'abs<)))
	  (cdr clause)))

;; INPUT
;; index-list: a list of integers are used as indexes of the list-of lists
;;             argument
;; list-of-lists: A list of lists, the contents of each list is unimportant.
;;                what is important is the length of each list, as it will 
;;                determine whether or not the integers in the index list can
;;                be incremented
;;
;; DESCRIPTION: This function attempts to increment the list of index values
;; "index-list" using the length of the lists contained in "list-of-lists" as
;; limits to how large each index value can be. The function moves right to 
;; left looking to add one to the values in index-list.  When it finds a 
;; value that is equal to the length of its corrosponding list in 
;; 'list-of-lists' it sets the index equal to zero then attempts to increment 
;; the next index to the left.  When there is no longer an index to the left
;; the algorithm returns nil.
;;
;; Examples: args: index-list=(0 1 0)   list-of-lists=((1 2) (3 4) (5))
;;          In this case index-list will be changed to (1 0 0), and the 
;;          function will return true.
;;
;;           args: index-list=(1 1 0)   list-of-lists=((1 2) (3 4) (5))
;;          In this case index-list will be set to (0 0 0) and the function 
;;          return false, as it was not able to increment any value the 
;;          index list.
;; OUTPUT
;; t - if the index-list was successfully incremented
;; nil - if the index-list was not incremented
(defun increment-index-list (index-list list-of-lists)
  (let ((index (- (length index-list) 1)) 
	(incremented t))
    (unless (= index -1)
      (while (= (nth index index-list) 
		(- (length (nth index list-of-lists)) 1))
	      (setf (nth index index-list) 0)
	      (decf index)
	      (if (= index -1)
		(return (setf incremented nil))))
      (if incremented (incf (nth index index-list)))
      incremented)))

;; input
;;   index-list: a list of integers
;;   list-of-constraints: a list of lists
;; output
;;   a list of the nth item in each list, where n is the corresponding
;;   integer in the index list
;; example
;;   (index-to-list '(0 1 2) '((a b) (c d) (e f))) --> (a d nil)
(defun index-to-list (index-list list-of-lists)
  ;; list lengths should be equal
  (cond ((/= (length index-list) (length list-of-lists))
	 (error "Bad arg to index-to-list"))
	(t 
	 (mapcar #'(lambda (idx lst) (nth idx lst)) index-list list-of-lists))))