;;;;; Test Library 3, for At Most One tests,
;; Containts three processes and two entites

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

(setf nutrient
      (create-generic-entity
       :type "nutrient"
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
(setf A
      (create-generic-process
       :name "Process_A"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))
		 
(setf B
      (create-generic-process
       :name "Process_B"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "N" :types (list nutrient)))))

(setf C
      (create-generic-process
       :name "Process_C"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer)))))


;;;;; CREATE THE LIBRARY OBJECT ;;;;;
(setf aq-test1-lib
      (make-library 
       :processes (list A B C)
       :entities (list producer nutrient)
       :constraints (list 
		     (make-process-set 
		      :name 'Growth 
		      :type 'exactly-one 
		      :items (list 
			      (create-item 
			       :proc A
			       :vars '((X . "P")(Y . "N")))
			      (create-item
			       :proc B
			       :vars '((Y . "N")))
			      (create-item
			       :proc C
			       :vars '((X . "P")))
			      )))))
