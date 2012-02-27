;(load "sc-ipm.lisp")
(load "./test_libs/predprey-lib2.lisp");library

;; producer 1
(setf prey1 
      (create-entity "aurelia" producer
		     :variables '(("conc" nil sum "aurelia"))))

(setf predator1
      (create-entity "nasutum" grazer
		     :variables '(("conc" nil sum "nasutum") ("grazing_rate" nil sum))
		     :constants '(("assim_eff") ("gmax") ("gcap") ("attack_rate"))))
(setf prey2 
      (create-entity "aurelia1" producer
		     :variables '(("conc" nil sum "aurelia"))))

(setf predator2
      (create-entity "nasutum1" grazer
		     :variables '(("conc" nil sum "nasutum") ("grazing_rate" nil sum))
		     :constants '(("assim_eff") ("gmax") ("gcap") ("attack_rate"))))

(setf prey3 
      (create-entity "aurelia2" producer
		     :variables '(("conc" nil sum "aurelia"))))

(setf predator3
      (create-entity "nasutum2" grazer
		     :variables '(("conc" nil sum "nasutum") ("grazing_rate" nil sum))
		     :constants '(("assim_eff") ("gmax") ("gcap") ("attack_rate"))))
(setf prey4 
      (create-entity "aurelia3" producer
		     :variables '(("conc" nil sum "aurelia"))))

(setf predator4
      (create-entity "nasutum3" grazer
		     :variables '(("conc" nil sum "nasutum") ("grazing_rate" nil sum))
		     :constants '(("assim_eff") ("gmax") ("gcap") ("attack_rate"))))

;; call sc-ipm with the list of instances 
(setf *current-library* pp-lib)
(setf sg (get-generator (list prey1 predator1 prey2 predator2 prey3 predator3 prey4 predator4) *current-library*))

;;(setf *data-sets* (list (read-data-from-file "pp-sim.data")))
;(setf m (random-structure sg))


