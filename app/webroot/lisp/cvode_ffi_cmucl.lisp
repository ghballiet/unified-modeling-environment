(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;; CVODE FFI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; this file provides a foreign-function interface to CVODE
;; the implementation targets CMUCL
;;
;; To avoid the complexities of shared memory, a C interface lets us
;; convert the model input from Lisp into the correct C structures.
;;
;; style note: FFI functions use the '_' character for variable and 
;; function names for compatibility with inferior languages.  Lisp
;; functions will use '-' by default.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package :alien)
(use-package :c-call)

;; the following functions allow faster access to all the fields in
;; the sys_var variable.  ideally we could access the memory directly,
;; but the FFI makes you jump through several function calls to get
;; there.  Here, we need only a single call.  Other Lisp environments
;; may have an improved FFI wrt foreign variables.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; BEGIN ACCESS FUNCTIONS ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(def-alien-routine get_sysvar_n int)

(def-alien-routine get_sysvar_val double
  (i int))

(def-alien-routine get_sysvar_dotval double
  (i int))

(def-alien-routine set_sysvar_val void
  (i int) 
  (x double))

(def-alien-routine set_sysvar_dotval void
  (i int) 
  (x double))

(def-alien-routine get_sensitivity double
  (pidx int)   ; the parameter index
  (vidx int))  ; the variable index

(def-alien-routine get_param_n int)

(def-alien-routine get_param_val double
  (i int))

(def-alien-routine set_param_val void
  (i int) 
  (x double))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; END ACCESS FUNCTIONS ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;
;;;; BEGIN FFI ;;;;
;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;; 
;;; init_dims
;;; 
;;; marshals information about the model from Lisp to CVODE.  Upon
;;; successful execution, the dimensions of key structures should be
;;; set so that later functions can allocate the proper amount of 
;;; memory and initialize other model-specific information.
;;;
;;; call this first for each new model to set the basic simulation
;;; parameters
;;;
(def-alien-routine init_dims void
  (nsys_var int) 
  (nparam int)
  (model (* (function void (double-float)))))


;;;;;;;;;;;;;;;;;
;;; mem_alloc
;;;
;;; upon successful execution, the structures used by CVODE will be
;;; allocated the appropriate amount of memory.
;;;
;;; init_dims must be called beforehand
;;;
(def-alien-routine mem_alloc int)


;;;;;;;;;;;;;;;;
;;; mem_free 
;;;
;;; frees the memory of the structures used by CVODE and created by
;;; mem_alloc.  this function should only be called once simulation of
;;; the current model is no longer needed.
;;;
;;; must be called before a new model is simulated, or a memory leak
;;; will occur.
;;;
(def-alien-routine mem_free void)


;;;;;;;;;;;;;;;
;;; fill_in 
;;;
;;; initializes some of the values in the structures used by CVODE
;;;
;;; must be called after mem_alloc, since many of the initialized structures
;;; are model-specific and created on the heap.
;;;
(def-alien-routine fill_in int
  (start_time double)
  (init_vals (* double-float))
  (sa int))


;;;;;;;;;;;;;;;;;;
;;; init_cvode
;;;
;;; resets the initial values to those specified by the init_vals
;;; parameter, and resets the starting time to the point stored in the
;;; time parameter.  the length of the init_vals parameter must be
;;; equivalent to that returned by get_sysvar_n.
;;;
;;; must be called sometime after fill_in and before each new
;;; simulation.  there is no other way to reset the state of the
;;; current model to the initial conditions.
;;;
(def-alien-routine init_cvode void
  (init_vals (* double-float))
  (start_time double))


;;;;;;;;;;;;;;;;;;;;;;;
;;; sim_model_cvode 
;;;
;;; used to solve the current model at the time specified by
;;; sample_time.  only forward simulation is allowed here.
;;;
;;; init_cvode must be called before the first call to this function,
;;; and if the simulation should be restarted from an earlier point.
;;;
(def-alien-routine sim_model_cvode int
  (sample_time double))


;;;;;;;;;;;;;;;;
;;; MS_model
;;;
;;; the placeholder for the Lisp function, called from C, that specifies
;;; the system of equations to be solved.

;;; For CMUCL, we don't need this prototype.  Instead, we define MS_model
;;; using "def-callback" instead of the normal "defun"

;(ffi:def-call-in MS_model 
;    (:arguments (t ffi:double-float))
;  (:return-type nil))

;;;;;;;;;;;;;;;;;
;;;; END FFI ;;;;
;;;;;;;;;;;;;;;;;