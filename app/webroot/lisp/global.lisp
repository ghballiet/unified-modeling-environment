(in-package :scipm)

;;;; GLOBAL.LISP ;;;;
;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;; GLOBAL VARIABLES ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;
;;;;; This file defines the global variables used throughout the
;;;;; inductive process modeling code.
;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#+cmu (extensions:set-floating-point-modes :traps '(:overflow :invalid))
;;; we're not trapping underflow, because CMUCL will normally just
;;; return a zero.

;;;; storage for the values of the algebraic variables
#-THREADED-SCIPM
(defvar *algebraic-variables* (make-array 0 :element-type 'double-float))

;;;; storage for the values of the exogenous variables
#-THREADED-SCIPM
(defvar *exogenous-variables* (make-array 0 :element-type 'double-float))

;;;; storage for the values of the system variables
#-THREADED-SCIPM
(defvar *system-variables* (make-array 0 :element-type 'double-float))

;;;; storage for the values of the model's constants including
;;;; constants and the initial values for both observed and unobserved
;;;; variables. the parameter estimation code is responsible for this
;;;; variable.
#-THREADED-SCIPM
(defvar *model-constants* (make-array 0 :element-type 'double-float))

#+allegro (declaim (type (simple-array double-float t) *algebraic-variables*
			 *exogenous-variables*
			 *system-variables*
			 *model-constants*))

#+(and sbcl (NOT THREADED-SCIPM))
(declaim (type (simple-array double-float *)
	       *algebraic-variables*
	       *exogenous-variables*
	       *system-variables*
	       *model-constants*))

#+clisp (declaim (type (simple-vector double-float) *algebraic-variables*
		       *exogenous-variables*
		       *system-variables*
		       *model-constants*))

;;;; storage for the current data set when multiple are used
#-THREADED-SCIPM
(defvar *current-data-set* nil)

;;;; a list of all the data sets currently being used
(defvar *data-sets* nil)

;;;; the model currently under the search focus
#+UNUSED (defvar *current-model* nil)

;;;; the current library, the most recently loaded library
;;;; (see library-definitions)
#+UNUSED (defvar *current-library* nil)

;;;; the most recent set of parameters loaded to search for a model
;;;; (see instance-definitions)
#+UNUSED (defvar *current-instances* nil)

;;;; the model-output-search object, a global used to create the files
;;;; that can rerun the model from the model search
#+model-output-search
(defvar *mos* nil)

#+THREADED-SCIPM
(defmacro with-rk-specials (&body body)
  `(let ((alg-array)
	 (sys-array)
	 (exo-array)
	 (const-array)
	 (var-idx-map (make-hash-table :test #'equal))
	 ;; the following were defvar'd in global.lisp, need to be local to thread
	 (*algebraic-variables* (make-array 0 :element-type 'double-float))
	 (*exogenous-variables* (make-array 0 :element-type 'double-float))
	 (*system-variables* (make-array 0 :element-type 'double-float))
	 (*model-constants* (make-array 0 :element-type 'double-float))
	 (*current-data-set* nil)
	 (*717-var-order* nil)
	 (predicted-717)
	 ;; the following will have a compiled function bound to them 
	 rk4_model_fnc
	 rk4_model_no_diffeq_fnc
	 #+DEBUG-ODE *debug-ode*
	 #+DEBUG-ODE *debug-non-ode*
	 #+DEBUG-SIM-CNT pe-sim-cnt
	 #+DEBUG-SIM-CNT pe-model-val)
     (declare 
      (special alg-array sys-array exo-array const-array var-idx-map
	       rk4_model_fnc rk4_model_no_diffeq_fnc
	       *algebraic-variables* *exogenous-variables* *system-variables*
	       *model-constants* *current-data-set*
	       *717-var-order*
	       predicted-717
	       #+DEBUG-ODE *debug-ode* #+DEBUG-ODE *debug-non-ode*
	       #+DEBUG-SIM-CNT pe-sim-cnt #+DEBUG-SIM-CNT pe-model-val)
      (type (simple-array double-float *)
	    *algebraic-variables* *exogenous-variables*
	    *system-variables* *model-constants*))
     ,@body))
