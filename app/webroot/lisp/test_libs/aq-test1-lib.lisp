;;;;; ROSS SEA LIBRARY FOR CB-IPM EXPERIMENTS ;;;;;

;;;; NOTES:
;;;;
;;;; The use of "exp" and "log" slow this code down substantially due
;;;; to memory and time inefficient implementations in CLISP.

;;;; this is the updated version of the ross sea library that no
;;;; longer includes a remineralization process for nitrate and has
;;;; the LHS of the nutrient limitation equations fixed to
;;;; P.growth_lim.


;;;;;; ENTITY TYPES ;;;;;;

(setf producer
      (create-generic-entity
       :type "producer"
       :variables (list
		   (make-variable-type
		    :name "conc" :aggregators '(sum))
		   (make-variable-type
		    :name "growth_rate" :aggregators '(prod))
		   (make-variable-type
		    :name "growth_lim" :aggregators '(min)))
       :constants (list
		   (make-constant-type
		    :name "max_growth" :upper-bound 0.8d0 :lower-bound 0.4d0)
		   (make-constant-type
		    :name "exude_rate" :upper-bound 0.2d0 :lower-bound 0.001d0)
		   (make-constant-type
		    :name "death_rate" :upper-bound 0.04d0 :lower-bound 0.02d0)
		   (make-constant-type
		    :name "ik_max" :upper-bound 100d0 :lower-bound 1d0)
		   (make-constant-type
		    :name "sinking_rate" :upper-bound 0.25d0 :lower-bound 0.0001d0)
		   (make-constant-type
		    :name "biomin" :upper-bound 0.04d0 :lower-bound 0.02d0)
		   (make-constant-type
		    :name "bioinhib" :upper-bound 201d0 :lower-bound 199d0))))

(setf fe
      (create-generic-entity
       :type "fe"
       :variables (list
		   (make-variable-type
		    :name "conc" :aggregators '(sum)))
       :constants (list
		   (make-constant-type
		    :name "toCratio" 
		    :upper-bound 450000d0 :lower-bound 3000d0)
		   (make-constant-type
		    :name "avg_deep_conc" :upper-bound 0.00045d0 :lower-bound 0.00035d0))))


;;;;; GENERIC PROCESSES ;;;;;

;;; GROWTH ;;;
(setf expG
      (create-generic-process
       :name "Exponential_Growth"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer)))))
		 
(setf logG
      (create-generic-process
       :name "Logistic_Growth"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer)))))

(setf limGA
      (create-generic-process
        :name "Limited_Growth_A"
        :equations (list (make-algebraic-equation
 			 :variable "P.growth_rate"
 			 :rhs '(* (- 1 "E.ice") "P.max_growth" 
 				(c_exp (coerce (* 0.0633 "E.th2o") 'double-float))
 				"P.growth_lim")))
        :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer)))))
(setf limGB
      (create-generic-process
        :name "Limited_Growth_B"
        :equations (list (make-algebraic-equation
 			 :variable "P.growth_rate"
 			 :rhs '(* (- 1 "E.ice") "P.max_growth" 
 				(c_exp (coerce (* 0.0633 "E.th2o") 'double-float))
 				"P.growth_lim")))
        :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list fe)))))

(setf limGF
      (create-generic-process
        :name "Limited_Growth_F"
        :equations (list (make-algebraic-equation
 			 :variable "P.growth_rate"
 			 :rhs '(* (- 1 "E.ice") "P.max_growth" 
 				(c_exp (coerce (* 0.0633 "E.th2o") 'double-float))
 				"P.growth_lim")))
        :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list fe)))))


;;;;; CREATE THE LIBRARY OBJECT ;;;;;
(setf aq-test1-lib
      (make-library 
       :processes (list expG logG limGA limGB limGF) 
       :entities (list producer fe) 
       :constraints (list 
		     (make-process-set
		      :name 'asd
		      :type 'for-each
		      :items (list
			      (create-item
			       :name 'Growth
			       :vars 
		     (make-process-set 
		      :name 'Growth 
		      :type 'one-of 
		      :items (list 
			      (create-item 
			       :name expG
			       :vars nil)
			      (create-item
			       :name logG
			       :vars nil)
			      (create-item
			       :name 'Limited_Growth)))
		     (make-process-set 
		      :name 'Limited_Growth 
		      :type 'always-together 
		      :items (list 
			      (create-item 
			       :name limGF
			       :vars nil)
			      (create-item
			       :name limGB
			       :vars nil)
			      (create-item
			       :name limGA
			       :vars nil))))))
			      
			    

		      
