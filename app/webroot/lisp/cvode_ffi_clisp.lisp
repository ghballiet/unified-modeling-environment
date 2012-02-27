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

(use-package "FFI")
(ffi:default-foreign-language :stdc)

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
(ffi:def-call-out get_sysvar_n
    (:name "get_sysvar_n")
  (:library "./cvode_interface.so")
  (:return-type ffi:int))

(ffi:def-call-out get_sysvar_val
    (:arguments (i ffi:int))
  (:name "get_sysvar_val")
  (:library "./cvode_interface.so")
  (:return-type ffi:double-float))

(ffi:def-call-out get_sysvar_dotval
    (:arguments (i ffi:int))
  (:name "get_sysvar_dotval")
  (:library "./cvode_interface.so")
  (:return-type ffi:double-float))

(ffi:def-call-out set_sysvar_val
    (:arguments (i ffi:int) (x ffi:double-float))
  (:name "set_sysvar_val")
  (:library "./cvode_interface.so")
  (:return-type nil))

(ffi:def-call-out set_sysvar_dotval
    (:arguments (i ffi:int) (x ffi:double-float))
  (:name "set_sysvar_dotval")
  (:library "./cvode_interface.so")
  (:return-type nil))

(ffi:def-call-out get_sensitivity
    (:arguments (pi ffi:int)   ; the parameter index
		(vi ffi:int))  ; the variable index
  (:name "get_sensitivity")
  (:library "./cvode_interface.so")
  (:return-type ffi:double-float))

(ffi:def-call-out get_param_n
    (:name "get_param_n")
  (:library "./cvode_interface.so")
  (:return-type ffi:int))

(ffi:def-call-out get_param_val
    (:arguments (i ffi:int))
  (:name "get_param_val")
  (:library "./cvode_interface.so")
  (:return-type ffi:double-float))

(ffi:def-call-out set_param_val
    (:arguments (i ffi:int) (x ffi:double-float))
  (:name "set_param_val")
  (:library "./cvode_interface.so")
  (:return-type nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; END ACCESS FUNCTIONS ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;; These next few functions are speed hacks because the default
;;;;; CLISP implementations are incredibly slow.
(ffi:def-call-out c_exp
    (:arguments (x ffi:double-float))
  (:name "c_exp")
  (:library "./cvode_interface.so")
  (:return-type ffi:double-float))

(ffi:def-call-out c_log
    (:arguments (x ffi:double-float))
  (:name "c_log")
  (:library "./cvode_interface.so")
  (:return-type ffi:double-float))

(ffi:def-call-out c_log10
    (:arguments (x ffi:double-float))
  (:name "c_log10")
  (:library "./cvode_interface.so")
  (:return-type ffi:double-float))


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
(ffi:def-call-out init_dims 
    (:name "init_dims")
    (:library "./cvode_interface.so")
    (:arguments (nsys_var ffi:int) 
		(nparam ffi:int)
		(model (ffi:c-function (:arguments (time ffi:double-float))
				       (:return-type nil))))
  (:return-type nil))


;;;;;;;;;;;;;;;;;
;;; mem_alloc
;;;
;;; upon successful execution, the structures used by CVODE will be
;;; allocated the appropriate amount of memory.
;;;
;;; init_dims must be called beforehand
;;;
(ffi:def-call-out mem_alloc (:library "./cvode_interface.so") 
  (:return-type ffi:int))


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
(ffi:def-call-out mem_free (:library "./cvode_interface.so")
  (:return-type nil))


;;;;;;;;;;;;;;;
;;; fill_in 
;;;
;;; initializes some of the values in the structures used by CVODE
;;;
;;; must be called after mem_alloc, since many of the initialized structures
;;; are model-specific and created on the heap.
;;;
(ffi:def-call-out fill_in (:library "./cvode_interface.so") 
  (:arguments (start_time ffi:double-float)
	      (init_vals (ffi:c-array-ptr ffi:double-float))
	      (sa ffi:int))
  (:return-type ffi:int))


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
(ffi:def-call-out init_cvode
  (:library "./cvode_interface.so")
  (:arguments (init_vals (ffi:c-array-ptr ffi:double-float))
	      (start_time ffi:double-float))
  (:return-type nil))


;;;;;;;;;;;;;;;;;;;;;;;
;;; sim_model_cvode 
;;;
;;; used to solve the current model at the time specified by
;;; sample_time.  only forward simulation is allowed here.
;;;
;;; init_cvode must be called before the first call to this function,
;;; and if the simulation should be restarted from an earlier point.
;;;
(ffi:def-call-out sim_model_cvode
  (:arguments (sample_time ffi:double-float))
  (:library "./cvode_interface.so") 
  (:return-type ffi:int))


;;;;;;;;;;;;;;;;
;;; MS_model
;;;
;;; the placeholder for the Lisp function, called from C, that specifies
;;; the system of equations to be solved.
(ffi:def-call-in MS_model 
    (:arguments (t ffi:double-float))
  (:return-type nil))

;;;;;;;;;;;;;;;;;
;;;; END FFI ;;;;
;;;;;;;;;;;;;;;;;
