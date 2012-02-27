(in-package :scipm)

;; (load "test_runs/predprey-run")
;; (RUN-SCIPM-RANDOM PP-LIB (LIST "foo.data") (LIST PREDATOR PREY) :NMODELS 1 
;; :NRESTARTS-FULL 1)
;;; for the pipeline
#+THREADED-SCIPM
(def-locked-var *nmodels*)
#+THREADED-SCIPM
(def-locked-var *models*)
#+THREADED-SCIPM
(def-locked-var *results-list*)
;;; for monitoring SAT performance
#+THREADED-SCIPM
(def-locked-var *invalid-model-eq-list*)
#+THREADED-SCIPM
(def-locked-var *models-not-found*)
#+THREADED-SCIPM
(def-locked-var *models-found*)
#+THREADED-SCIPM
(def-locked-var *model-retries-exceeded*)
;;; debugging
#+THREADED-SCIPM
(def-locked-var *type-error-count*)
#+THREADED-SCIPM
(def-locked-var *error-flag*)

#+THREADED-SCIPM
(defun run-scipm-random (instance-library-name
			 &key (nmodels 100) (sim-routine 'rk4)
			 (search-routine 'walksat)
			 (nrestarts-full 10) (normalize t)
			 (filter-results #'identity)
			 given-random-state
			 (model-retries 5)
			 (failure-limit-multiplier 100))
  (let* ((current-instances (instance-library instance-library-name))
	 (current-library (instance-library-generic-library current-instances))
	 (start-time (get-universal-time))
	 ;; make a copy of random-state so that we can reset to this
	 (random-state (mt19937::make-random-state (or given-random-state *random-state*)))
	 (data-filenames (instance-library-data-files current-instances))
	 (entities (instance-library-entities current-instances))
	 (generic-library-version (generic-library-version current-library)))
    ;;; debug
    (setf *type-error-count* nil *error-flag* nil)
    ;;; end-debug
    (setf *data-sets* (mapcar #'read-data-from-file data-filenames))
    (when given-random-state (setf *random-state* given-random-state))
    (calculate-dispersions *data-sets*)
    (let ((generator (get-generator entities current-library
				    ;; convert to CNF for walksat or dpll
				    :cnf? (not (eq search-routine 'and-or)))))
      (setf *nmodels* nmodels
	    *models* ()
	    *results-list* ()
	    *invalid-model-eq-list* ()
	    *models-not-found* 0
	    *models-found* 0
	    *model-retries-exceeded* NIL)
      (flet ((get-model (nth)
	       (let ((model-retry-cnt 0)
		     model)
		 (loop until (and (not *model-retries-exceeded*)
				  (>= model-retry-cnt model-retries)
				  (< (+ (length *invalid-model-eq-list*) *models-not-found*)
				     (* nmodels failure-limit-multiplier)))
		    do (progn 
			 (setf model
			       (cond ((eq search-routine 'and-or)
				      (andor-structure generator :idx nth))
				     ((eq search-routine 'walksat)
				      (walksat-structure generator :idx nth))))
			 (if model
			     (let ((invalid-eqs (valid-model? model)))
			       (incf *models-found*)
			       (if invalid-eqs
				   (push (list model invalid-eqs) *invalid-model-eq-list*)
				   (return model)))
			     (and (incf *models-not-found*) (incf model-retry-cnt)))))
		 (if model
		     model
		     (when (>= model-retry-cnt model-retries)
		       (setf *model-retries-exceeded* T)
		       NIL))))
	     (valid-parameterized-model (model)
	       (with-rk-specials
		(let ((new-result
		       (cond ((eq sim-routine 'cvode)
			      ;; assumes SSE or normalized SSE evaluation function
			      (scipm-717-cvode model nrestarts-full normalize))
			     ((eq sim-routine 'rk4)
			      ;; assumes SSE or normalized SSE evaluation function	     
			      (scipm-717-rk4 model nrestarts-full normalize)))))
		  ;; note the < ordering for the objective
		  ;; we may need to generalize this at some point.
		  ;; scipm-717-[cvode|rk4]-model returns a list:
		  ;;   (best-params best-score &opt best-sim)
		  (when (second new-result) ; nil implies no convergent solution found
		    (push model new-result))))))
	(multiple-value-bind (model-results-list non-convergent)
	    (loop for result-list
	       in (with-threaded-pipe
		      ((*nmodels*
			get-model
			*models*
			1)		; walksat not re-entrant
		       (*models*
			valid-parameterized-model
			*results-list*
			1)))
	       if (null (first result-list))
	       count 1 into non-convergent
	       else collect (first result-list) into convergent
	       finally (return (values convergent non-convergent)))
	  (setf *RESULTS*
		(list :saved-p nil
		      :instance-library-name instance-library-name
		      :generic-library-version generic-library-version
		      :random-state random-state
		      :start-time start-time
		      :data-sets *data-sets*
		      :nmodels nmodels
		      :sim-routine sim-routine
		      :search-routine search-routine
		      :nrestarts-full nrestarts-full
		      :normalize normalize
		      :filter-results filter-results
		      :model-results (funcall filter-results 
					      (sort model-results-list
						    #'< :key #'third))
		      :no-convergent-solution non-convergent
		      :invalid-model-eqs *invalid-model-eq-list*))
	  (format nil "MODELS FOUND: ~A~%~
                 MODELS with no CONVERGENT SOLUTION: ~A~%~
                 MODELS NOT FOUND: ~A~%~
                 INVALID MODELS FOUND: ~A~%~A~%"
		  *models-found*
		  non-convergent
		  *models-not-found*
		  (length *invalid-model-eq-list*)
		  (if *model-retries-exceeded*
		      "STOPPED BECAUSE MODEL-RETRIES EXCEEDED"
		      "")))))))

#-THREADED-SCIPM
(defun run-scipm-random (instance-library-name
			 &key (nmodels 100) (sim-routine 'rk4)
			 (search-routine 'walksat)
			 (nrestarts-full 10) (normalize t)
			 (filter-results #'identity)
			 given-random-state
			 (model-retries 5)
			 (failure-limit-multiplier 100))
  (let* ((current-instances (instance-library instance-library-name))
	 (current-library (instance-library-generic-library current-instances))
	 (start-time (get-universal-time))
	 ;; make a copy of random-state so that we can reset to this
	 (random-state (mt19937::make-random-state (or given-random-state *random-state*)))
	 (data-filenames (instance-library-data-files current-instances))
	 (entities (instance-library-entities current-instances))
	 (generic-library-version (generic-library-version current-library)))
    (setf *data-sets* (mapcar #'read-data-from-file data-filenames))
    (when given-random-state (setf *random-state* given-random-state))
  ;; add keywords for simulation (rk4/cvode), evaluation (normalized?)
  ;; search-routine: walksat, dpll, or and-or
  ;; number of restarts, number of structures, fit initial values, 
  ;; suppress-sim?, estimation routine
  (calculate-dispersions *data-sets*)
  (let (run-sum
	new-result
	model-results-list
	model
	(invalid-model-eq-list ())
	(generator (get-generator entities current-library
				  ;; convert to CNF for walksat or dpll
				  :cnf? (not (eq search-routine 'and-or)))))
    (let ((i 1) ; make model names start at MODEL-1
	  (no-model-retry 0)
	  (models-found 0)
	  (models-not-found 0))
      (while (and (<= i nmodels) 
		  (< no-model-retry model-retries)
		  (< (+ (length invalid-model-eq-list) models-not-found)
		     (* nmodels failure-limit-multiplier)))
	(cond ((eq search-routine 'and-or)
	       (setf model (andor-structure generator :idx i)))
	      ((eq search-routine 'walksat)
	       (setf model (walksat-structure generator :idx i
					      ; :reinit (= i 1) ; reinit everytime
					      ))))              ; otherwise it breaks

	(if model
	    (progn 
	      (incf models-found)
	      (setf no-model-retry 0))
	    (progn
	      (incf models-not-found)
	      (incf no-model-retry)))
	(when model
	  (let ((invalid-eqs (valid-model? model)))
	    (when invalid-eqs (push (list model invalid-eqs) invalid-model-eq-list))
	    ;; print out the bad set of equations for debugging 
	    #+scipm-debug (when invalid-eqs
			    (terpri)(princ "*********************************")
			    (terpri)(princ "* incorrect processes are found *")
			    (terpri)(princ "*********************************")
			    (terpri)(princ "*** model ***")
			    (terpri)(princ model)
			    (terpri)(princ "*** incorrect processes ***")
			    (terpri)(princ invalid-eqs)
			    (terpri)(princ "*** end of printout ***"))
    
	    ;; if all's well, then fit the model parameters
	    (unless invalid-eqs
	      (cond ((eq sim-routine 'cvode)
		     ;; assumes SSE or normalized SSE evaluation function
		     (setf new-result (scipm-717-cvode model nrestarts-full normalize)))
		    ((eq sim-routine 'rk4)
		     ;; assumes SSE or normalized SSE evaluation function	     
		     (setf new-result (scipm-717-rk4 model nrestarts-full normalize))))
	      ;; note the < ordering for the objective 	      ;; we may need to generalize this at some point.
	      ;; scipm-717-[cvode|rk4]-model returns a list: (best-params best-score &opt best-sim)
	      (when (second new-result)
		(push (push model new-result) model-results-list)
		(incf i))))))
      (setf run-sum (list
		     models-found 
		     models-not-found 
		     (length invalid-model-eq-list)
		     (if (= model-retries no-model-retry)
		       "STOPPED BECAUSE MODEL-RETRIES EXCEEDED"
		       ""))))
    (setf *RESULTS*
	  (list :saved-p nil
		:instance-library-name instance-library-name
		:generic-library-version generic-library-version
		:random-state random-state
		:start-time start-time
		:data-sets *data-sets*
		:nmodels nmodels
		:sim-routine sim-routine
		:search-routine search-routine
		:nrestarts-full nrestarts-full
		:normalize normalize
		:filter-results filter-results
		:model-results (funcall filter-results 
					(sort model-results-list #'< :key #'third))
		:invalid-model-eqs invalid-model-eq-list
		:run-sum run-sum))
    (format nil "MODELS FOUND: ~{~A~%~
                 MODELS NOT FOUND: ~A~%~
                 INVALID MODELS FOUND: ~A~%~A~}~%" run-sum))))

(defun scipm-717-cvode (model nrestarts normalize?) 
  (let (init-val-list init-val-array results)
    (cvode-prepare-model model nil)

    (setf init-val-list (cvode-initial-data-values nil))
    (setf init-val-array (make-array (length init-val-list)
				     :element-type 'double-float
				     :initial-contents init-val-list))
    (fill_in (coerce (datum-time (car *data-sets*) 0) 'double-float)
	     #+cmu (sys:vector-sap init-val-array)
	     #-cmu init-val-array
	     0)

    (setf results (pe-717 model *data-sets* (getv-constants) 
			  #'combined-sim-cvode #'cvode-data-init 
			  #'cvode-sim-error? #'sim-model-717-cvode 
			  #'eval-model-717-sse nrestarts
			  :normalize normalize?
			  :suppress-sim t))
    (cvode-clean-up)
    results))


(defun scipm-717-rk4 (model nrestarts normalize?)
  (let #+(AND COMPILED-LAMBDA (NOT THREADED-SCIPM)) (rk4_model_fnc rk4_model_no_diffeq_fnc)
       #-(AND COMPILED-LAMBDA (NOT THREADED-SCIPM)) ()
       #+(AND COMPILED-LAMBDA (NOT THREADED-SCIPM))
       (declare (special rk4_model_fnc rk4_model_no_diffeq_fnc))
       (rk4-prepare-model model)
       (format nil "~A~%" model)
       ;;    (let ((rk4_model_fnc (compile 'rk4_model (eval f1)))
       ;;	  (rk4_model_no_diffeq_fnc (compile 'rk4_model_no_diffeq (eval f2))))
       ;;      (declare (special rk4_model_fnc rk4_model_no_diffeq_fnc))
       (pe-717 model *data-sets* (getv-constants) 
	       #'combined-sim-rk4 #'rk4-data-init 
	       #'rk4-sim-error? #'sim-model-717-rk4
	       #'eval-model-717-sse nrestarts
	       :normalize normalize?
	       :suppress-sim NIL)))


;; Make sure the model is valid.  Specifically checks whether all
;; variables that occur on the RHS of an equation also appear on the
;; LHS of an equation.
(defun valid-model? (model)
  (let ((lst (build-equations model))
	(all-vars)
	(invalid-eqs)
	(rhs))

    ;; get a list of variables that are exogenous or assigned a value
    (setf all-vars (apply #'append (separate-variables model lst)))
    
    ;; check whether all variables in rhs exist in the variable list
    (dolist (eq (combine-equations lst) invalid-eqs)
      (setf rhs (cond ((differential-equation-p eq)
		       (diff-eq-rhs eq))
		      ((algebraic-equation-p eq)
		       (alg-eq-rhs eq))))
      (if (set-difference (hash-table-keys (extract-variables rhs))
			  all-vars 
			  :test #'equalp)
	  (push eq invalid-eqs)))))

(defun run-scipm (instance-library-name &optional (sim-routine 'rk4))
    (run-scipm-random  instance-library-name
		       :nmodels 5 
		       :nrestarts-full 2 
		       :sim-routine sim-routine))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

