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
		    :aggregators '(sum)))))

;; generic-entity producer
;; variables conc{sum}
(setf producer 
      (create-generic-entity
       :type "producer"
       :variables (list
		   (make-variable-type
		    :name "conc"
		    :aggregators '(sum)))))

;; generic-process h1-pred{predation}
;; constants efficiency[0,1], attack-rate[0,2]
;; entities G{grazer}, P{producer}
;; equations d[P.conc,t,1] = -1 * attack-rate * P.conc * G.conc,
;;           d[G.conc,t,1] = efficiency * attack-rate * P.conc * G.conc
(setf h1-pred
      (create-generic-process
       :name "h1-predation"
       :type "predation"
       :constants (list
		   (make-constant-type
		    :name "efficiency"
		    :upper-bound 1d0
		    :lower-bound 0d0)
		   (make-constant-type
		    :name "attack_rate"
		    :upper-bound 2d0
		    :lower-bound 0d0))
       :equations (list (make-differential-equation
			 :variable "P.conc"
			 :rhs '(* -1d0 "attack_rate" "P.conc" "G.conc"))
			(make-differential-equation
			 :variable "G.conc"
			 :rhs '(* "efficiency" "attack_rate" "P.conc" "G.conc")))
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
       :type "loss"
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
	 :type "growth"
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
	 :type "growth"
	 :constants (list (make-constant-type
			   :name "growth_rate"
			   :upper-bound 3d0
			   :lower-bound 0d0)
			  (make-constant-type
			   :name "k"
			   :upper-bound 0.5d0
			   :lower-bound 0d0))
	 :equations (list (make-differential-equation
			   :variable "P.conc"
			   :rhs '(* "growth_rate" "P.conc" (- 1 (* "k" "P.conc")))))
	 :e-roles  (list (make-entity-role
			  :name "P"
			  :types (list producer)))))


;; generic-process root{root}
;; entities G{grazer}, P{producer}
;; processes growth(P), loss(G), predation(P,G)
(setf root-pp
      (create-generic-process
       :name "root-pp"
       :type "root-pp"
       :e-roles (list  (make-entity-role
			:name "G"
			:types (list grazer))
		       (make-entity-role
			:name "P"
			:types (list producer)))
       :p-roles (list (make-process-role
		       :name "growth"
		       :arguments '("P"))
		      (make-process-role
		       :name "predation"
		       :arguments '("P" "G"))
		      (make-process-role
		       :name "loss"
		       :arguments '("G")))))

(setf pp-lib 
      (make-library 
       :processes (list h1-pred exp-loss exp-growth log-growth root-pp)
       :entities (list producer grazer)))

;;; this code will generate all models described by the library
;; list of entity instances
;; (setf temp (list-of-all-models predprey pp-lib))