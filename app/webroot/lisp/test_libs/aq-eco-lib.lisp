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
(setf gProc
      (create-generic-process
       :name "growth"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list fe)))))

;;;;; CREATE THE LIBRARY OBJECT ;;;;;
(setf aq-eco-lib
      (make-library 
       :processes (list gProc) 
       :entities (list producer fe) 
       :constraints (list (make-process-set 
			      :name 'growth 
			      :type 'always-together 
			      :items (list 
				      (create-item
				       :name gProc
				       :vars nil))))))
				       

(push
 (make-process-set 
	:name 'mutex 
	:type 'one-of 
	:items (list
	    (create-item 
	     :name gProc
	     :vars nil))) (lib-constraints aq-eco-lib))
