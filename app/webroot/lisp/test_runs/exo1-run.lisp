;;;;;;;;;;;;;;;;;;;;;; Aquadic Ecosystem Sample ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; this file contains an example of a library for testing
;;; purposes in cb-ipm
;;; 
;;; This sample instantiated libary file uses the aq-eco-lib.lisp
;;; to generate models from these instances
;;;
(load "sc-ipm.lisp")
(load "./tlibs/exo1.lisp");library

;; producer 1
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
	 :generic-entity producer
	 :variables vhash
	 :comment "")))

(setf p2
      (let ((vhash (make-hash-table :test #'equal)))
	(setf (gethash "conc" vhash)
	      (make-variable?
	       :type (gethash "conc" (generic-entity-variables producer))
	       :initial-value nil
	       :data-name "producer1"
	       :aggregator 'sum
	       :comment ""))
	(make-entity
	 :name "producer2"
	 :generic-entity producer
	 :variables vhash
	 :comment "")))

;; Nutrient 1
(setf n1
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
	 :generic-entity nutrient
	 :variables vhash
	 :comment "")))

;; call sc-ipm with the list of instances 
(setf sol-g (create-solution-generator (list p1 p2 n1) aq-test1-lib))
(format t "~S~%" (exhaustive sol-g 'dnf))