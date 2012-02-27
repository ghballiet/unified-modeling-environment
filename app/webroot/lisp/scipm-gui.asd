(require :mcclim)  ; CLIM public implementation - declaritive (G)UI language
(require :scipm)

(shadowing-import '(clim::accept
		    clim::line) (find-package :scipm))
(shadowing-import '(clim-lisp::describe
		    clim-lisp::describe-object)
		  (find-package :scipm))
(shadowing-import '(clim-lisp-patch::defconstant
		    clim-lisp-patch::interactive-stream-p
		    clim-lisp-patch::defclass
		    #-THREADED-SCIPM clim-lisp-patch::make-hash-table)
		  (find-package :scipm))

(use-package '(:clim :clim-lisp :clim-tab-layout) (find-package :scipm))

(in-package :scipm)

(defsystem :scipm-gui
  :version "0.9.2"
  :license "Isle"
  :components ((:module "GUI"
			:serial T
			:pathname ""
			:components (
				     (:file "mcclim-patch")
				     (:file "option-gadget")
				     (:file "scipm-frame")
				     ))))

;;;;;;;=================

#+FOOBAR
(do-symbols (x (find-package :scipm) t) 
  (when (multiple-value-bind (p k) 
	    (find-symbol (symbol-name x) (find-package :scipm))
	  (and (eq (symbol-package p) (find-package :scipm))
	       (or (eq k :internal) (eq k :external))))
    (export x (find-package :scipm))))

#+NOT-YET
(defpackage :scipm-gui
  (:use :cl :asdf :sb-alien :sb-c-call 
	:clim :clim-lisp :clim-tab-layout
	:scipm)
  (:shadowing-import-from :clim accept)
  (:shadowing-import-from :clim-lisp
			  describe
			  describe-object)
  (:shadowing-import-from :clim-lisp-patch
			  defconstant
			  interactive-stream-p
			  defclass)
  #+THREADED-SCIPM
  (:shadowing-import-from :scipm
			  make-hash-table))

#+NOT-YET ;; export list for scipm if you want to make this be a separate pkg
(:export
   name
   initial-value
   data-name
   exogenous
   upper-bound
   lower-bound
   units
   variable
   type
   aggregators
   comment
   format*
   *generic-file-type*
   *generic-library-path*
   *generic-library-version*
   *instance-file-type*
   *instance-library-path*
   *instance-library-version*
;   versioned-generic-library-pathname
;   versioned-generic-library-name
;   set-generic-library
;   reset-generic-libraries
   *results*
   pathname-string
   make-constraint
   constraint
   make-constraint-modifier
   constraint-modifier
   constraint-name
   constraint-items
   constraint-type
   conmod-gprocess
   conmod-modifiers
   make-differential-equation
   differential-equation
   diff-eq-variable
   diff-eq-respect-to
   diff-eq-order
   diff-eq-rhs
   make-algebraic-equation
   algebraic-equation
   alg-eq-variable
   alg-eq-rhs
   make-entity-role
   entity-role
   entity-role-name
   entity-role-types
   generic-entity
   generic-entity-type
   generic-entity-constants
   generic-entity-variables
   generic-entity-comment
   generic-process
   gp-comment
   gp-constants
   gp-conditions
   gp-entity-roles
   gp-equations
   gp-name
   variable-type
   make-constant-type
   constant-type
   constant-type-name
   create-generic-process
   process-constraints
   process-entity-parameters
   process-generic-process 
   print-gp-summary
   generic-library
   lib-entities
   lib-processes
   lib-name
   lib-constraints
   save-generic-library
   variable?
   constant?
   constant?-type
   entity
   entity-name
   entity-generic-entity
   entity-variables
   entity-constants
   entity-comment
   instance-library
   instance-library-name
   instance-library-generic-library
   instance-library-data-files
   instance-library-entities
   model
   model-name
   model-entities
   model-processes
   ;;;
   constant-type-comment
   constant-type-lower-bound
   constant-type-units
   constant-type-upper-bound
   lib-modified
   lib-version
   variable-type-aggregators
   variable-type-comment
   variable-type-lower-bound
   variable-type-name
   variable-type-units
   variable-type-upper-bound
   constant-type-comment
   constant-type-lower-bound
   constant-type-units
   constant-type-upper-bound
   create-generic-entity
   find-entity
   hash-table-keys
   hash-table-values-keys
   instance-library-version
   keyword-value
   lib-modified
   lib-version
   plot-model-simulation
   prepare-constant-args
   prepare-constraint-args
   prepare-entity-args
   prepare-process-args
   print-constraint-summary
   print-diff-eq-rhs
   print-entity
   print-ge
   process-entity-roles
   processes-binding-entity
   remove-constraint-from-library
   remove-process-from-library
   results-directory-pathname
   run-scipm-random
   save-results
   save-to-generic-db
   show-model-equations
   variable-type-aggregators
   variable-type-comment
   variable-type-lower-bound
   variable-type-name
   variable-type-units
   variable-type-upper-bound
   with-indent)


