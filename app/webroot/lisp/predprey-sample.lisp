;;;;;;;;;;;;;;;;;;;;;; Predprey Run ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; this file contains an example of a hand-created model using   
;;; the library in predprey lib.  there are several complications
;;; here that can be simplified through the creation of some 
;;; helper macros and functions, but until those are finished, the
;;; functions below are indicative of the work involved.
;;;


;;; now we have to figure out how to create a model
;;; the biggest challenge here is how to deal with variables and constants
;;; they have to be model specific, but there are aspects of them that
;;; we hope will be data file specific as well.
;;; XXX: variable-type has a bunch of crap that belongs to variable
;;; XXX: how do we support process level variables when they have to be 
;;;      associated with some data column?  How do we give them default
;;;      values per instantiation?  We would have to support partially
;;;      instantiated processes to do this.

(load "sc-ipmc.lisp")
(load "predprey-lib");; library
(setf *data-sets* (list (read-data-from-file "foo.data"))) ;; data set

(setf aurelia 
      (let ((vhash (make-hash-table :test #'equal)))
	(setf (gethash "conc" vhash)
	      (make-variable?
	       :type (gethash "conc" (generic-entity-variables producer))
	       :initial-value nil
	       :data-name "aurelia"
	       :aggregator 'sum
	       :comment ""))
	(make-entity
	 :name "aurelia"
	 :generic-entity producer
	 :variables vhash
	 :comment "")))

(setf nasutum
      (let ((vhash (make-hash-table :test #'equal)))
	(setf (gethash "conc" vhash)
	      (make-variable?
	       :type (gethash "conc" (generic-entity-variables grazer))
	       :initial-value nil
	       :data-name "nasutum"
	       :aggregator 'sum
	       :comment ""))
	(make-entity
	 :name "nasutum"
	 :generic-entity grazer
	 :variables vhash
	 :comment "")))

;; call sc-ipm with the list of instances 
(setf sol-g (create-solution-generator (list aurelia nasutum)))
;(format t "~S~%" (exhaustive sol-g 'dnf))
(setf all-models (exhaustive sol-g *data-sets* 'dnf))

