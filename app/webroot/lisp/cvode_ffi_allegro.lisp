(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;; CVODE FFI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; this file provides a foreign-function interface to CVODE
;; the implementation targets CLISP
;;
;; CLISP cannot be used with CVODE directly as it does not support
;; forward declarations of types---a necessity for the complex
;; structures used by CVODE.  As a result, an interface in C converts
;; the input from Lisp into the correct C structures.
;;
;; style note: FFI functions use the '_' character for variable and 
;; function names for compatibility with inferior languages.  Lisp
;; functions will use '-' by default.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package :ff)
(require :foreign)

;; the following functions allow faster access to all the fields in
;; the sys_var variable.  ideally we could access the memory directly,
;; but the FFI makes you jump through several function calls to get
;; there.  Here, we need only a single call.  Other Lisp environments
;; may have an improved FFI wrt foreign variables.
;;
;; See the optional implementation at the end of this file for a
;; possible replacement access method in the presence of a faster FFI.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; BEGIN ACCESS FUNCTIONS ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(ff:def-foreign-call get_sysvar_n (:void)
  :returning :int)

(ff:def-foreign-call get_sysvar_val ((i :int))
  :returning :double)

(ff:def-foreign-call get_sysvar_dotval ((i :int))
  :returning :double)

(ff:def-foreign-call set_sysvar_val ((i :int) 
				      (x :double)))

(ff:def-foreign-call set_sysvar_dotval ((i :int) 
				    (x :double)))

(ff:def-foreign-call get_sensitivity ((pidx :int)   ; the parameter index
				      (vidx :int))  ; the variable index
  :returning :double)

(ff:def-foreign-call get_param_n (:void)
  :returning :int)

(ff:def-foreign-call get_param_val ((i :int))
  :returning :double)

(ff:def-foreign-call set_param_val ((i :int) (x :double)))

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
(ff:def-foreign-call init_dims ((nsys_var :int) 
				(nparam :int)
				(fptr :int))
  :returning nil)


;;;;;;;;;;;;;;;;;
;;; mem_alloc
;;;
;;; upon successful execution, the structures used by CVODE will be
;;; allocated the appropriate amount of memory.
;;;
;;; init_dims must be called beforehand
;;;
(ff:def-foreign-call mem_alloc (:void)
  :returning :int)


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
(ff:def-foreign-call mem_free (:void)
  :returning nil)


;;;;;;;;;;;;;;;
;;; fill_in 
;;;
;;; initializes some of the values in the structures used by CVODE
;;;
;;; must be called after mem_alloc, since many of the initialized structures
;;; are model-specific and created on the heap.
;;;
(ff:def-foreign-call fill_in ((start_time :double)
			      (init_vals (:array :double))
			      (sa :int))
  :returning :int)


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
(ff:def-foreign-call init_cvode 
    ((init_vals (:array :double))
     (start_time :double))
  :returning nil)


;;;;;;;;;;;;;;;;;;;;;;;
;;; sim_model_cvode 
;;;
;;; used to solve the current model at the time specified by
;;; sample_time.  only forward simulation is allowed here.
;;;
;;; init_cvode must be called before the first call to this function,
;;; and if the simulation should be restarted from an earlier point.
;;;
(ff:def-foreign-call sim_model_cvode
    ((sample_time :double))
  :returning :int)


;;;;;;;;;;;;;;;;
;;; MS_model
;;;
;;; the placeholder for the Lisp function, called from C, that specifies
;;; the system of equations to be solved.
;;;
;;; not needed for Allegro
;(ffi:def-call-in MS_model 
;    (:arguments (t :double))
;  (:returning nil))

;;;;;;;;;;;;;;;;;
;;;; END FFI ;;;;
;;;;;;;;;;;;;;;;;