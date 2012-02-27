(in-package :scipm)

;; this implementation of walksat is based closely on the official
;; version written in C.  That implies that the functions all have
;; some sort of side effect.

;; each atom has an index from 1 to n
;; each literal falls in [1,n] or [-n,-1]

;; much of the code assumes that there is no atom "0" because the
;; greater/less than 0 relationship is used to indicate a negated
;; atom in a clause.  there may be a bug or two associated with 
;; the use of this offset 

;; each atom stored as a bit
(defvar atoms (make-array 0 :element-type 'bit))
(declaim (type (bit-vector *) atoms))

;; the clauses, where each element is a positive or negative index into atoms
(defvar	clauses (make-array 0))
(declaim (type (simple-array (simple-array fixnum *) *) clauses))

;; ntruelit[i]: the number of true literals in clauses[i]
(defvar ntruelit (make-array 0 :element-type 'fixnum))
(declaim (type (simple-array fixnum *) ntruelit))

;; makecount[i]: the number of clauses that become satisfied when
;; atoms[i] is flipped
(defvar makecount (make-array 0 :element-type 'fixnum))
(declaim (type (simple-array fixnum *) makecount))

;; breakcount[i]: the number of clauses that become unsatisfied when
;; atoms[i] is flipped
(defvar breakcount (make-array 0 :element-type 'fixnum))
(declaim (type (simple-array fixnum *) breakcount))

;; numoccurrences[0,i]: the number of negative occurrences of atom i 
;; numoccurrences[1,i]: the number of positive occurrences of atom i
(defvar numoccurrences (make-array '(0 0)))
(declaim (type (simple-array t) numoccurrences))

;; occurrences[0,i]: a list of hard indices to clauses that contain negative atom i
;; occurrences[1,i]: a list of hard indices to clauses that contain positive atom i
(defvar occurrences (make-array '(0 0)))
(declaim (type (simple-array t) occurrences))

;; the number of false clauses
(defvar numfalse 0)
;; RAB - add type dec'l for SBCL optimization
(declaim (type fixnum numfalse))

;; the number of flips made
(defvar numflip 0)

;; keep track of the last time a particular atom was flipped
(defvar changed (make-array 0))

;; a collection of indices of false clauses
(defvar false-clauses (make-array 0 :element-type 'fixnum))
(declaim (type (simple-array fixnum *) false-clauses))

;; where-in-false[i]: the index of clauses[i] in false-clauses
(defvar where-in-false (make-array 0 :element-type 'fixnum))
(declaim (type (simple-array fixnum *) where-in-false))

;; used by certain pick functions to control bookkeeping
(defvar makeflag nil)

;; clause-lst - list of lists
(defun walksat (natoms clause-lst &optional (target 0) (cutoff 100000))
  ;; initialize the unchanging information about the problem
  (ws-initprob natoms clause-lst)

  ;; repeat from here until the end if you want multiple assignments
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
      atoms
    nil))

(defun ws-init ()
  (let (thetruelit)
    (dotimes (clause-idx (array-dimension clauses 0) numfalse)
      ;; count the true literals in each clause
      (dotimes (lit-idx (array-dimension (aref clauses clause-idx) 0))
	(let ((literal (aref (aref clauses clause-idx) lit-idx)))
	  (when (eq (> literal 0) ; meaning it is true in the clause (not negative numb)
		    (> (bit atoms (abs literal)) 0)) ; and is "arbitrarily" true (boolean)
	    (incf (aref ntruelit clause-idx))
	    (setf thetruelit (abs literal)))))
      (cond ((= (aref ntruelit clause-idx) 0)
	     ;; if the clause is completely unsatisfied, flipping any
	     ;; of the variables in the clause will satisfy it
	     (setf (aref false-clauses numfalse) clause-idx)
	     (setf (aref where-in-false clause-idx) numfalse)
	     (incf numfalse)
	     (dotimes (lit-idx (array-dimension (aref clauses clause-idx) 0))
	       (incf (aref makecount (abs (aref (aref clauses clause-idx) lit-idx))))))
	    ((and thetruelit (= (aref ntruelit clause-idx) 1))
	     ;; RAB if the lit ain't true, don't increment
	     ;; (besides thetruelit will be nil and will break the aref)
	     ;; if the clause is satisfied by only one variable, then
	     ;; flipping it will make the clause unsatisfied.
	     (incf (aref breakcount thetruelit)))))))

;; initialize problem-specific structures
;; all values set in this function hold true throughout the solution
;; of this problem.
(defun ws-initprob (natoms clause-lst)
  (let ((nclauses (length clause-lst))
	(natoms+ (+ natoms 1)))
    ;; initialize structures to the proper size and type
    ;; we need to create enough room for n+1 atoms because a negated index
    ;; indicates that the literal corresponding to that atom is (boolean)
    ;; negated
    (setf atoms (make-array natoms+ :element-type 'bit))
    (setf clauses (make-array nclauses))
    (setf false-clauses (make-array nclauses :initial-element -1 :element-type 'fixnum))
    (setf where-in-false (make-array nclauses :initial-element 0 :element-type 'fixnum))
    (setf ntruelit (make-array nclauses :initial-element 0 :element-type 'fixnum))
    (setf makecount (make-array natoms+ :initial-element 0 :element-type 'fixnum))
    (setf breakcount (make-array natoms+ :initial-element 0 :element-type 'fixnum))
    (setf numoccurrences (make-array (list 2 natoms+) :initial-element 0))
    ;; RE: :initial-element () in following line of code
    ;; hyperspec: If initial-element is not supplied, the consequences of later reading
    ;; an uninitialized element of new-array are undefined ...
    ;; RAB: "later reading" would include "push"
    (setf occurrences (make-array (list 2 natoms+) :initial-element ()))
    (setf changed (make-array natoms+))
    (setf numfalse 0)
    (setf numflip 0)
    (setf makeflag nil))

  ;; store clauses as an array of arrays
  (map-into clauses 
	    #-SBCL #'(lambda (x) 
		(make-array (length x) 
			    :initial-contents x))
	    #+SBCL #'(lambda (x) 
		       (let* ((l (length x))
			      (arr (make-array l :element-type 'fixnum)))
			 (loop for i 
			    from 0 
			    upto (1- l)
			    do (setf (aref arr i) (nth i x)))
			 arr))
		     clause-lst)
  
  ;; fill in the number of occurrences of each literal
  ;; store indices of clauses where each literal occurs
  (dotimes (cl-idx (array-dimension clauses 0))
    (dotimes (lit-idx (array-dimension (aref clauses cl-idx) 0))
      (let ((lit (aref (aref clauses cl-idx) lit-idx)))
	(if (> lit 0)
	    (progn 
	      (incf (aref numoccurrences 1 lit))
	      (push cl-idx (aref occurrences 1 lit)))
	  (progn
	    (incf (aref numoccurrences 0 (- lit)))
	    (push cl-idx (aref occurrences 0 (- lit)))))))))


(defun ws-pickrandom () 
  ;; randomly pick an unsatisfied clause
  ;; return a random variable in that clause
  (let ((rand-clause (aref clauses (aref false-clauses (random numfalse)))))
    (abs (aref rand-clause (random (array-dimension rand-clause 0))))))

(defun ws-pickbest ()
  (declare (optimize (speed 3) (safety 0)))
  ;; randomly pick an unsatisfied clause
  (let ((rand-clause (aref clauses (aref false-clauses (random numfalse))))
	(bestvalue 100000000) ;; arbitrary number from walksat code
	(best))
    (declare (type (vector fixnum) rand-clause))
    ;; walk through each literal in the randomly selected clause
    ;; pick the atom that will falsify the fewest clauses
    ;; if several atoms tie, randomly pick among them
    (dotimes (lit-idx (array-dimension rand-clause 0))
      (let ((atom-idx (abs (aref rand-clause lit-idx))))
	(cond ((< (aref breakcount atom-idx) bestvalue)
	       (setf bestvalue (aref breakcount atom-idx))
	       (setf best (list atom-idx)))
	      ((= (aref breakcount atom-idx) bestvalue)
	       (push atom-idx best)))))

    ;; randomly decide to return a random flip
    ;;  if (bestvalue>0 && (random()%denominator < numerator))
    (cond ((and (> bestvalue 0) (< (random 100) 50))
	   ;; if flipping the atom will falsify at least one clause,
	   ;; and if a random condition is met, randomly select an
	   ;; atom from the clause to falsify
	   (abs (aref rand-clause (random (array-dimension rand-clause 0)))))
	  ((= (length best) 1)
	   ;; if there are no ties, return the sole best atom
	   (first best))
	  (t
	   ;; otherwise, randomly break the tie
	   (nth (random (length best)) best)))))

(defun ws-flipatom (toflip)
  (declare (fixnum toflip)
	   (optimize (speed 3) (safety 0)))
  (let (toenforce occlst)
    (setf (aref changed toflip) numflip)
    ;; grab the literal that will become true after the bit flip
    (setf toenforce (if (> (bit atoms toflip) 0) (- toflip) toflip))
    ;; flip the bit
    (setf (bit atoms toflip) (- 1 (bit atoms toflip)))
    
    ;; grab the number of occurrences of the literal that's now *false*
;    (setf numocc (if (> toenforce 0)
;		     (aref numoccurrences 0 toenforce)
;		   (aref numoccurrences 1 (- toenforce))))

    ;; grab the list of clauses that contain the newly false literal
    (setf occlst (if (> toenforce 0)
		     (aref occurrences 0 toenforce)
		   (aref occurrences 1 (- toenforce))))

    ;; update the clauses that are losing a true literal
    (dolist (clause-idx occlst)
      (decf (aref ntruelit clause-idx))
      (cond ((= (aref ntruelit clause-idx) 0)
	     ;; the clause was just falsified...
	     ;; perform book keeping on clauses that are now false
	     (setf (aref false-clauses numfalse) clause-idx)
	     (setf (aref where-in-false clause-idx) numfalse)
	     (incf numfalse)
	     (decf (aref breakcount toflip))
	     ;; update the makecount for pick functions that care
	     (when makeflag
	       (dotimes (lit-idx (array-dimension (aref clauses clause-idx) 0))
		 (incf (aref makecount (abs (aref (aref clauses clause-idx) lit-idx)))))))
	    ((= (aref ntruelit clause-idx) 1)
	     ;; the clause is close to being falsified...
	     ;; find the one literal in the clause that makes it true and 
	     ;; increment the number of clauses that flipping it will falsify
	     (dotimes (lit-idx (array-dimension (aref clauses clause-idx) 0))
	       (let ((lit (aref (aref clauses clause-idx) lit-idx)))
		 (when (eq (> lit 0)
			   (> (bit atoms (abs lit)) 0))
		   (incf (aref breakcount (abs lit)))
		   (return)))))))

    ;; grab the number of occurrences of the literal that's now *true*
;    (setf numocc (if (> toenforce 0)
;		     (aref numoccurrences 1 toenforce)
;		   (aref numoccurrences 0 (- toenforce))))

    ;; grab the list of clauses that contain the newly true literal
    (setf occlst (if (> toenforce 0)
		     (aref occurrences 1 toenforce)
		   (aref occurrences 0 (- toenforce))))
    
    ;; update the clauses that are gaining a true literal
    (dolist (clause-idx occlst)
      (incf (aref ntruelit clause-idx))
      (cond ((= (aref ntruelit clause-idx) 1)
	     ;; the clause was just satisfied...
	     ;; perform book keeping on clauses that are now true
	     (decf numfalse)
	     (setf (aref false-clauses (aref where-in-false clause-idx)) 
		   (aref false-clauses numfalse))
	     (setf (aref where-in-false (aref false-clauses numfalse))
		   (aref where-in-false clause-idx))

	     (incf (aref breakcount toflip))
	     ;; update the makecount for pick functions that care
	     (when makeflag
	       (dotimes (lit-idx (array-dimension (aref clauses clause-idx) 0))
		 (decf (aref makecount (abs (aref (aref clauses clause-idx) lit-idx)))))))
	    ((= (aref ntruelit clause-idx) 2)
	     ;; the clause is far from being falsified...
	     ;; find the one literal in the clause that makes it true other than
	     ;; the one just flipped and decrement its breakcount 
	     (dotimes (lit-idx (array-dimension (aref clauses clause-idx) 0))
	       (let ((lit (aref (aref clauses clause-idx) lit-idx)))
		 (when (and (eq (> lit 0)
				(> (bit atoms (abs lit)) 0))
			    (/= toflip (abs lit)))
		   (decf (aref breakcount (abs lit)))
		   (return)))))))))


;; check whether a given truth assignment satisfies the formula
(defun ws-verify (atom-v clause-2d)
  (declare (type (bit-vector *) atom-v))
  (when atom-v
    (let (sat-clause lit)
      (dotimes (clause-idx (array-dimension clause-2d 0))
	(setf sat-clause nil)
	(dotimes (lit-idx (array-dimension (aref clause-2d clause-idx) 0))
	  (setf lit (aref (aref clause-2d clause-idx) lit-idx))
	  (when  (eq (> lit 0)
		     (> (bit atoms (abs lit)) 0))
	    (setf sat-clause t)
	    (return)))
	(unless sat-clause (return-from ws-verify nil))))
    t))
