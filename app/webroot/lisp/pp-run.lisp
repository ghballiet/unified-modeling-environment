;;;;;;;;;;;;;;;;;;;;;; Aquadic Ecosystem Sample ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; this file contains an example of a library for testing
;;; purposes in cb-ipm
;;; 
;;; This sample instantiated libary file uses the aq-eco-lib.lisp
;;; to generate models from these instances
;;;
(load "sc-ipm.lisp")
(load "./libs/pred-prey.lisp");library

;; Producer 1
(setf p1 
      (let ((vhash (make-hash-table :test #'equal)))
	(setf (gethash "conc" vhash)
	      (make-variable?
	       :type (gethash "conc" (generic-entity-variables producer))
	       :initial-value nil
	       :data-name "producer1"
	       :aggregator 'sum
	       :comment ""))
	(make-entity
	 :name "producer1"
	 :generic-entity p
	 :variables vhash
	 :comment "")))

;; (setf p2
;;       (let ((vhash (make-hash-table :test #'equal)))
;; 	(setf (gethash "conc" vhash)
;; 	      (make-variable?
;; 	       :type (gethash "conc" (generic-entity-variables producer))
;; 	       :initial-value nil
;; 	       :data-name "producer1"
;; 	       :aggregator 'sum
;; 	       :comment ""))
;; 	(make-entity
;; 	 :name "producer2"
;; 	 :generic-entity producer
;; 	 :variables vhash
;; 	 :comment "")))

;; Grazer 1
(setf g1
      (let ((vhash (make-hash-table :test #'equal)))
	(setf (gethash "conc" vhash)
	      (make-variable?
	       :type (gethash "conc" (generic-entity-variables nutrient))
	       :initial-value nil
	       :data-name "iron"
	       :aggregator 'sum
	       :comment ""))
	(make-entity
	 :name "iron"
	 :generic-entity g
	 :variables vhash
	 :comment "")))

;; call sc-ipm with the list of instancesaq-test1-lib
(setf sol-g (create-solution-generator (list p1 g1) aq-test1-lib))
(format t "~S~%" (exhaustive sol-g 'dnf))