;;; This a library taken from the (would be) example
;;; in the sc-ipm paper.

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; ENTITY TYPES ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setf producer
      (create-generic-entity
       :type "producer"
       :variables (list
		   (make-variable-type
		    :name "conc" :aggregators '(sum))
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
		    :name "biomin" :upper-bound 0.04d0 :lower-bound 0.02d0)
		   (make-constant-type
		    :name "bioinhib" :upper-bound 201d0 :lower-bound 199d0))))

(setf grazer
      (create-generic-entity
       :type "grazer"
       :variables (list
		   (make-variable-type
		    :name "conc" :aggregators '(sum))
		   (make-variable-type
		    :name "growth_rate" :aggregators '(min)))
       :constants (list
		   (make-constant-type
		    :name "max_growth" :upper-bound 0.8d0 :lower-bound 0.4d0)
		   (make-constant-type
		    :name "death_rate" :upper-bound 0.04d0 :lower-bound 0.02d0)
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
(setf environment
      (create-generic-entity
       :type "environment"
       :variables (list
		   (make-variable-type
		    :name "conc" :aggregators '(sum)))
       :constants (list
		   (make-constant-type
		    :name "toCratio" 
		    :upper-bound 450000d0 :lower-bound 3000d0)
		   (make-constant-type
		    :name "avg_deep_conc" :upper-bound 0.00045d0 :lower-bound 0.00035d0))))



(setf degradation
      (create-generic-entity
       :type "degradation"
       :variables (list
		   (make-variable-type
		    :name "conc" :aggregators '(sum)))
       :constants (list
		   (make-constant-type
		    :name "toCratio" 
		    :upper-bound 450000d0 :lower-bound 3000d0)
		   (make-constant-type
		    :name "avg_deep_conc" :upper-bound 0.00045d0 :lower-bound 0.00035d0))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; GENERIC PROCESSES ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; NECESSARY PROCESSES ;;;;

;;; Remineralization ;;;
(setf remin
      (create-generic-process
       :name "Remineralization"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "D" :types (list degradation))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))
;;; Grazing ;;;
(setf grazing
      (create-generic-process
       :name "Grazing"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "G" :types (list grazer))
		 )))
;;; respiration ;;;
(setf respiration
      (create-generic-process
       :name "Respiration"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 )))
;;; nutrient mixing ;;;
(setf nut_mix
      (create-generic-process
       :name "Nutrient_Mixing"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))
;;; growth ;;;
(setf growth
      (create-generic-process
       :name "Growth"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 (make-entity-role
		  :name "E" :types (list environment))
		 )))
;;; sinking ;;;
(setf sinking
      (create-generic-process
       :name "Sinking"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "E" :types (list environment))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))
;;; nutrient uptake ;;;
(setf nutrient_uptake
      (create-generic-process
       :name "Nutrient_Uptake"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 (make-entity-role
		  :name "E" :types (list environment))
		 )))
;;; exudation ;;;
(set exudation
      (create-generic-process
       :name "Exudation"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 (make-entity-role
		  :name "E" :types (list environment))
		 )))

;;; GROWTH RATE ALTERNATIVES ;;;

;;; pearl-verhulst ;;;
(setf pearl-v
      (create-generic-process
       :name "Pearl_Verhulst"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))
;;; gompertz ;;;
(setf gompertz
      (create-generic-process
       :name "Gompertz"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))
;;; resourse/temp limitation ;;;
(setf rt_limitation
      (create-generic-process
       :name "Resourse_and_Temperature_Limitation"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))

;;; GRAZING ALTERNATIVES ;;;

;;; watts
(setf watts
      (create-generic-process
       :name "Watts"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "G" :types (list nutrient))
		 )))
;;; ivlev
(setf ivlev
      (create-generic-process
       :name "Ivlev"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "G" :types (list nutrient))
		 )))
;;; lotka-volterra
(setf lot_volt
      (create-generic-process
       :name "Lotka_Volterra"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "G" :types (list nutrient))
		 )))

;;; NUTRIENT ALTERNATIVES ;;;
;; 1st order monod
(setf monod1
      (create-generic-process
       :name "1st_Order_Monod"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))
;; 2nd order monod
(setf monod2
      (create-generic-process
       :name "2nd_Order_Monod"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))
;; exponential
(setf exponential
      (create-generic-process
       :name "Exponential"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))

;;; LIGHT ALTERNATIVES ;;;
(setf no_photo
      (create-generic-process
       :name "No Photoinhibition"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))
(setf photo
      (create-generic-process
       :name "Photoinhibition"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "N" :types (list nutrient))
		 )))

;;; MORTALITY ALTERNATIVES ;;;
(setf no_photo
      (create-generic-process
       :name "No Photoinhibition"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "D" :types (list degradation))
		 )))
(setf photo
      (create-generic-process
       :name "Photoinhibition"
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* "P.growth_rate" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "P" :types (list producer))
		 (make-entity-role
		  :name "D" :types (list degradation))
		 )))



;;;;; CREATE THE LIBRARY OBJECT ;;;;;
(setf sb-ross-lib
      (make-library 
       :processes (list A B C)
       :entities (list producer nutrient)
       :constraints (list 
		     (make-process-set 
		      :name 'Growth 
		      :type 'always-together 
		      :items (list 
			      (create-item 
			       :proc A
			       :vars nil)
			      (create-item
			       :proc B
			       :vars nil)
			      (create-item
			       :proc C
			       :vars nil)
			      )))))
