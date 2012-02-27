;;;;;;;;;;;;;;;;;;;;;; Aquadic Ecosystem Sample ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; this file contains an example of a library for testing
;;; purposes in cb-ipm
;;; 
;;; This sample instantiated libary file uses the aq-eco-lib.lisp
;;; to generate models from these instances
;;;
(load "sc-ipm.lisp")
(load "./libs/aq-eco.lisp");library

;; Phyto
(setf phyto 
      (make-entity
       :name "Phyto"
       :generic-entity pe
       :comment ""))

;; Phyto
(setf zoo
      (make-entity
       :name "Zoo"
       :generic-entity ze
       :comment ""))

;; Nitrate
(setf nit
      (make-entity
       :name "Nitrate"
       :generic-entity ne
       :comment ""))
;; Iron
(setf fe
      (make-entity
       :name "Iron"
       :generic-entity ie
       :comment ""))

;; Detritus
(setf det
      (make-entity
       :name "Detritus"
       :generic-entity de
       :comment ""))

;; Environment
(setf env
      (make-entity
       :name "Environment"
       :generic-entity ee
       :comment ""))

;; call sc-ipm with the list of instancesaq-test1-lib
(setf sol-g (create-solution-generator (list phyto zoo nit fe det env) aq-lib))
(format t "~S~%" (exhaustive sol-g 'dnf))