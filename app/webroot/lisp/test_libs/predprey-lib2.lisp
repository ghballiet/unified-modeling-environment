;; This library is specifically for testing constraints


;; NOTE: all constants, bounds, and so on should be explicitly
;; specified as double-floats to avoid the need to cast when
;; performing calculations that interact with C code.  The finalized
;; version of the library/model building interface should include
;; functions that take care of the cast at definition time so that
;; users don't need to worry about this ugly little monster.

;; build the entities

;; generic-entity grazer
;; variables conc{sum}
(setf grazer
      (create-generic-entity
       :type "grazer"
       :variables (list
		   (make-variable-type
		    :name "conc"
		    :aggregators '(sum))
		   (make-variable-type
		    :name "grazing_rate"
		    :aggregators '(sum)))
       :constants (list
		   (make-constant-type
		    :name "assim_eff"
		    :lower-bound 0.001d0
		    :upper-bound 0.8d0)
		   (make-constant-type
		    :name "gmax"
		    :lower-bound 0.0001d0
		    :upper-bound 1d0)
		   (make-constant-type
		    :name "gcap"
		    :lower-bound 10d0
		    :upper-bound 10000d0)
		   (make-constant-type
		    :name "attack_rate"
		    :lower-bound 0.3d0
		    :upper-bound 10d0))))

;; generic-entity producer
;; variables conc{sum}
(setf producer 
      (create-generic-entity
       :type "producer"
       :variables (list
		   (make-variable-type
		    :name "conc"
		    :aggregators '(sum)))))

(setf grazing
      (create-generic-process
       :name "grazing"
       :equations (list (make-differential-equation
			 :variable "G.conc"
			 :rhs '(* "G.assim_eff" "G.grazing_rate" "G.conc"))
			(make-differential-equation
			 :variable "P.conc"
			 :rhs '(* -1d0 "G.grazing_rate" "G.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Lotka-Volterra predation
(setf h1-pred
      (create-generic-process
       :name "lotka-volterra"
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.gmax" "P.conc")))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Holling disk equation
(setf h2-pred
      (create-generic-process
       :name "holling-disk-equation"
       ;; "h" is the extra handling time: L.Gross says - Handling
       ;; time is defined as the time spent pursuing, subduing, and
       ;; consuming each prey item plus the time spent preparing to
       ;; search for the next prey item (including effects of satiation)
       ;; :: SRB - I don't know if this is appropriate
       ;; if h < 1 then the max of the response function exceeds 1
       :constants (list (make-constant-type
			 :name "h"
			 :lower-bound 1d0
			 :upper-bound 5d0))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(/ (* "G.attack_rate" "P.conc") 
				  (+ 1d0 (* "G.attack_rate" "h" "P.conc")))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Holling type III equation
(setf h3-pred
      (create-generic-process
       :name "holling-type-3"
       :constants (list (make-constant-type
			 :name "h"
			 :lower-bound 1d0
			 :upper-bound 5d0))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(/ (* "G.attack_rate" "P.conc" "P.conc") 
				  (+ 1d0 (* "G.attack_rate" "h" "P.conc" "P.conc")))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Generalized Gause
;; reported in Rosenzweig 1971, a generalization of lotka-volterra
(setf gen-gause
      (create-generic-process
       :name "generalized-gause"
       :constants (list (make-constant-type
			 :name "alpha"
			 :lower-bound 0.0001d0 ; alpha = 0, then function reduces
			 :upper-bound 0.9999d0 ; alpha = 1, then it equals lotka-volterra
			 ))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.gmax" (expt "P.conc" "alpha"))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))
;; Monod
;; from Arrigo et al. 1998 (CIAO model)
(setf monod
      (create-generic-process
       :name "monod"
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(max 0d0 (* "G.gmax" (/ "P.conc" 
						       (+ "G.gcap" "P.conc"))))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Ivlev
;; this appears in Rozensweig 1971 w/o a reference to Ivlev
(setf ivlev
      (create-generic-process
       :name "ivlev"
       :constants (list (make-constant-type
			 :name "delta"
			 :lower-bound 0.001d0
			 :upper-bound 1d0 ;; technically could be greater than 1
			 ))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.gmax" (- 1d0 (exp (* -1d0 "P.conc" "delta"))))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Ratio Dependent (2) 
;; See Jost and Ellner 2000
(setf ratio-dep-2
      (create-generic-process
       :name "ratio-dependent-2"
       :constants (list (make-constant-type
			 :name "h"
			 :lower-bound 1d0
			 :upper-bound 5d0 
			 ))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.attack_rate" (/ "P.conc" 
						     (+ "G.conc" (* "G.attack_rate" "h" "P.conc"))))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Ratio Dependent (3) 
;; See Jost and Ellner 2000
(setf ratio-dep-3
      (create-generic-process
       :name "ratio-dependent-3"
       :constants (list (make-constant-type
			 :name "h"
			 :lower-bound 1d0
			 :upper-bound 5d0 
			 ))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.attack_rate" (/ (* "P.conc" "P.conc")
						     (+ (* "G.conc" "G.conc") 
							(* "G.attack_rate" "h" "P.conc" "P.conc"))))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Watts
;; See Jost and Ellner 2000
(setf watts
      (create-generic-process
       :name "watts"
       :constants (list (make-constant-type
			 ;; higher value increases grazing rate
			 :name "delta"
			 :lower-bound 0.01d0
			 :upper-bound 0.5d0)
			(make-constant-type
			 ;; higher value retards grazing rate
			 :name "m"
			 :lower-bound 0.0001d0
			 :upper-bound 0.9999d0))
       ;; range taken from the the alpha parameter of the generalized_gause process,
       ;; since watts is a generalization of ivlev analogous to the generalized_gause
       ;; generalization of lotka_volterra
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.gmax" (- 1d0 (exp (* -1d0 "delta" (/ "P.conc" 
									 (expt "G.conc" "m"))))))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Hassell Varley 1
;; See Jost and Ellner 2000
(setf hv-1
      (create-generic-process
       :name "hassell-varley-1"
       :constants (list (make-constant-type
			 ;; higher value retards growth
			 :name "sigma"
			 :lower-bound 1d0
			 :upper-bound 100d0))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.gmax" "P.conc" (expt "G.conc" (* -1d0 "sigma")))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Hassell Varley 2
;; See Jost and Ellner 2000
(setf hv-2
      (create-generic-process
       :name "hassell-varley-2"
       :constants (list (make-constant-type
			 :name "sigma"
			 :lower-bound 0.0001d0
			 :upper-bound 0.9999d0)
			(make-constant-type
			 :name "h"
			 :lower-bound 1d0
			 :upper-bound 5d0))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.attack_rate" (/ "P.conc"
						     (+ (expt "G.conc" "sigma") 
							(* "G.attack_rate" "h" "P.conc"))))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))

;; Deangelis Beddington
;; See Jost and Ellner 2000
(setf deangelis
      (create-generic-process
       :name "deangelis-beddington"
       :constants (list (make-constant-type
			 :name "delta"
			 :lower-bound 0d0
			 :upper-bound 1d0)
			(make-constant-type
			 :name "h"
			 :lower-bound 1d0
			 :upper-bound 5d0))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.attack_rate" (/ "P.conc"
						     (+ 1d0 (* "delta" "G.conc")
							(* "G.attack_rate" "h" "P.conc"))))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))


;; Crowley Martin
;; See Jost and Ellner 2000
(setf crowley
      (create-generic-process
       :name "crowley-martin"
       :constants (list (make-constant-type
			 :name "delta"
			 :lower-bound 0d0
			 :upper-bound 1d0)
			(make-constant-type
			 :name "h"
			 :lower-bound 1d0
			 :upper-bound 5d0))
       :equations (list (make-algebraic-equation
			 :variable "G.grazing_rate"
			 :rhs '(* "G.attack_rate" (/ "P.conc"
						     (* (+ 1d0 (* "G.attack_rate" "h" "P.conc"))
							(+ 1d0 (* "delta" "G.conc")))))))
       :e-roles (list 
		 (make-entity-role
		  :name "G"
		  :types (list grazer))
		 (make-entity-role
		  :name "P"
		  :types (list producer)))))


;; generic-process exp-loss{loss}
;; constants loss_rate[0,2]
;; entities G{grazer}
;; equations d[G.conc,t,1] = -1 * loss_rate * G.conc
(setf exp-loss
      (create-generic-process
       :name "exponential-loss"
       :constants (list (make-constant-type
			 :name "loss_rate"
			 :upper-bound 2d0
			 :lower-bound 0d0))
       :equations (list (make-differential-equation
			   ;; note that we don't know the actual type of 
			   ;; g, so we can't access the variable field
			   ;; directly, so we just reference it with a string
			   :variable "G.conc"
			   ;; each variable and each constant is just referred
			   ;; to by its string name.  we'll resolve these into
			   ;; the real-life values later in the process
			   ;; not that we'll just replace members of this
			   ;; equation with the actual variables.
			   :rhs '(* -1d0 "loss_rate" "G.conc")))
       :e-roles (list (make-entity-role
		       :name "G"
		       :types (list grazer)))))


;; generic-process exp-growth{growth}
;; constants growth_rate[0,2]
;; entities P{producer}
;; equations d[P.conc,t,1] = growth_rate * G.conc
(setf exp-growth
      (create-generic-process
       	 :name "exponential-growth"
	 :constants (list (make-constant-type
			   :name "growth_rate"
			   :upper-bound 3d0
			   :lower-bound 0d0))
	 :equations (list (make-differential-equation
			   :variable "P.conc"
			   :rhs '(* "growth_rate" "P.conc")))
	 ;:conditions (list '(> "P.conc" 0d0))
	 :e-roles  (list (make-entity-role
			  :name "P"
			  :types (list producer)))))

;; generic-process log-growth{growth}
;; constants growth_rate[0,2], k[0,0.5]
;; entities P{producer}
;; equations d[P.conc,t,1] = growth_rate * G.conc * (1 - k * P.conc)
(setf log-growth
      (create-generic-process
       	 :name "logistic-growth"
	 :constants (list (make-constant-type
			   :name "growth_rate"
			   :upper-bound 3d0
			   :lower-bound 0d0)
			  (make-constant-type
			   :name "saturation"
			   :upper-bound 0.1d0
			   :lower-bound 0d0))
	 :equations (list (make-differential-equation
			   :variable "P.conc"
			   :rhs '(* "growth_rate" "P.conc" (- 1d0 (* "saturation" "P.conc")))))
	 :e-roles  (list (make-entity-role
			  :name "P"
			  :types (list producer)))))

;;;; XXX: including all the predation processes kills the CNF 
;;;;      conversion code for some reason.  DNF works fine.
(setf pp-lib 
      (make-library 
       :processes (list h1-pred 
			 h2-pred h3-pred gen-gause monod 
			 ivlev ratio-dep-2 ratio-dep-3 watts hv-1 hv-2 
			 deangelis crowley
			grazing exp-loss 
			 exp-growth 
			log-growth)
       :entities (list producer grazer)
       :constraints (list 
			(make-constraint
                            :name 'growth-mutex
                            :type 'exactly-one
                            :items (list (create-conmod :gp exp-growth :mods '((A . "P")))
                                         (create-conmod :gp log-growth :mods '((A . "P")))))
			(make-constraint
			 :name 'grazing-req
			 :type 'exactly-one
			 :items (list (create-conmod :gp grazing :mods '((A . "P") (B . "G")))))
			(make-constraint
			 :name 'death-req
			 :type 'exactly-one
			 :items (list (create-conmod :gp exp-loss :mods '((A . "G")))))
			(make-constraint
			 :name 'predation-req
			 :type 'exactly-one
			 :items (list (create-conmod :gp h1-pred :mods '((A . "P") (B . "G")))
				      (create-conmod :gp h2-pred :mods '((A . "P") (B . "G")))
				      (create-conmod :gp h3-pred :mods '((A . "P") (B . "G")))
				      (create-conmod :gp gen-gause :mods '((A . "P") (B . "G")))
				      (create-conmod :gp monod :mods '((A . "P") (B . "G")))
				      (create-conmod :gp ivlev :mods '((A . "P") (B . "G")))
				      (create-conmod :gp ratio-dep-2 :mods '((A . "P") (B . "G")))
				      (create-conmod :gp ratio-dep-3 :mods '((A . "P") (B . "G")))
				      (create-conmod :gp watts :mods '((A . "P") (B . "G")))
				      (create-conmod :gp hv-1 :mods '((A . "P") (B . "G")))
				      (create-conmod :gp hv-2 :mods '((A . "P") (B . "G")))
				      (create-conmod :gp deangelis :mods '((A . "P") (B . "G")))
				      (create-conmod :gp crowley :mods '((A . "P") (B . "G")))
				      )))))

