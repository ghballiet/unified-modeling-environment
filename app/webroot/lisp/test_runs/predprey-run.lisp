;(load "sc-ipm.lisp")
(load "./test_libs/predprey-lib.lisp");library

;; producer 1
(setf prey 
      (create-entity "aurelia" producer
		     :variables '(("conc" nil sum "aurelia"))))

(setf predator
      (create-entity "nasutum" grazer
		     :variables '(("conc" nil sum "nasutum") ("grazing_rate" nil sum))
		     :constants '(("assim_eff") ("gmax") ("gcap") ("attack_rate"))))

;; call sc-ipm with the list of instances 
(setf *current-library* pp-lib)
;;; RAB - call to get-generator seems pointless
(setf sg-old (get-generator (list prey predator) *current-library*))
;;(setf *data-sets* (list (read-data-from-file "pp-sim.data")))
;(setf m (random-structure sg))

;;(run-scipm-random pp-lib '("pp-sim.data") (list prey predator)
;;	:nmodels 5 :nrestarts-full 2)
