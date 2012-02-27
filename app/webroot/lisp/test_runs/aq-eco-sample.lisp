;;;;;;;;;;;;;;;;;;;;;; Aquadic Ecosystem Sample ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; this file contains an example of a library for testing
;;; purposes in cb-ipm
;;; 
;;; This sample instantiated libary file uses the aq-eco-lib.lisp
;;; to generate models from these instances
;;;

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
;; producer 2
(setf p2
      (let ((vhash (make-hash-table :test #'equal)))
	(setf (gethash "conc" vhash)
	      (make-variable?
	       :type (gethash "conc" (generic-entity-variables producer))
	       :initial-value nil
	       :data-name "producer2"
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
	       :type (gethash "conc" (generic-entity-variables fe))
	       :initial-value nil
	       :data-name "iron"
	       :aggregator 'sum
	       :comment ""))
	(make-entity
	 :name "iron"
	 :generic-entity fe
	 :variables vhash
	 :comment "")))


;; call cb-ipm with the list of instances
(setf sol-g (create-solution-generator (list p1 p2 n1) aq-eco-lib))
;(lib-to-CNF pp-lib)
;(format t "~S~%" (get-model pp-lib))
;(format t "~S~%" pp-lib)
;(list-of-all-models pp-lib (list aurelia nasutum))