#+clisp (setf CUSTOM:*floating-point-contagion-ansi* t
	      CUSTOM:*default-float-format* 'double-float)

(when (member :SB-THREAD *FEATURES*) (push :THREADED-SCIPM *FEATURES*))
(push :COMPILED-LAMBDA *FEATURES*)

#+THREADED-SCIPM
(require :bordeaux-threads)
(require :MT19937) ; Mersenne Twister portable random number generator

(defpackage :scipm
  (:use :cl 
	:asdf
	:sb-alien :sb-c-call 
	#+THREADED-SCIPM :bt)
  #+THREADED-SCIPM
  (:shadow make-hash-table))

(in-package :scipm)
(shadowing-import '(MT19937:RANDOM MT19937:*RANDOM-STATE*)) ; shadowing CL:RANDOM

(defsystem :scipm
  :version "0.9.1" ; because the cvode/ffi isn't finished (how to load dyn lib) or tested
  :license "Isle"
  :depends-on (:sb-callback)
  :components ((:module "c-dynamic-libraries"
			:components (
	       #+(and allegro dlfcn) (:foreign "./cvode_interface.so")
	       #+(and allegro dlmac) (:foreign "./cvode_c_interface.dylib")
	       #+cmu (:foreign extensions:load-foreign "./cvode_interface.so")
	       #+sbcl-not-yet (:foreign sb-alien:load-shared-object "./cvode_interface.so")))
	       (:module "main"
			:serial T
			:pathname ""
			:components (#+THREADED-SCIPM
				     (:file "sbcl-hash-patch")
				     (:file "global")
				     (:file "general")
				     (:file "utils")
				     #+THREADED-SCIPM
				     (:file "thread-control")
				     (:file "data")
				     (:file "gp")
				     (:file "model")
				     (:file "walksat")
				     (:file "symbols")
				     (:file "cnf")
				     (:file "library")
				     (:file "structure-generator")
				     (:file "constraint")
				     (:file "logic-generator")
				     (:file "library-definition")
				     (:file "instance-definition")
;;				     (:file "file-list") 
;;                                           vars set only ref'd by model-output-search
				     (:file "results")
				     (:file "interface")
				     (:file "plot-models")
				     (:file "save-equations")
;;				     (:file "model-output-search")
;;                                          init-mos calls undefined functions "exhaustive"
;;	                                    and "create-solution-generator"
				     ))
	       (:module "f2cl"
			:depends-on ("main")
			:serial T
			:components ((:file "f2cl0")
				     (:file "macros")))
	       (:module "cvode"
			:depends-on ("main" "f2cl")
			:serial T
			:pathname ""
			:components ((:file "build_equations")
				     (:file "combine_equations")
				     (:file "general_make_sys")
				     (:file "cvode_make_sys")
	   #+(and clisp (not macos)) (:file "cvode_ffi_clisp")
			   #+allegro (:file "cvode_ffi_allegro")
			       #+cmu (:file "cvode_ffi_cmucl")
			      #+sbcl (:file "cvode_ffi_sbcl")
				     (:file "cvode")
				     (:file "pe_general")
				     (:file "pe_obj_funcs")))
	       (:module "717"
			:depends-on ("f2cl")
			:serial T
			:pathname "toms/717"
			:components ((:file "da7sst")
				     (:file "dd7mlp")
				     (:file "dd7tpr")
				     (:file "dd7up5")
				     (:file "df7dhb")
				     (:file "dl7msb")
				     (:file "dl7mst")
				     (:file "do7prd")
				     (:file "dvsum")
	                  #-allegro  (:file "dg7itb") ; called by drglgb
				     (:file "dg7qsb")
				     (:file "dg7qts")
			             (:file "dglfb")  ; called from pe-717
				     (:file "dh2rfa")
				     (:file "dh2rfg")
			  #-allegro  (:file "ditsum")
				     (:file "divset")
				     (:file "dl7itv")
				     (:file "dl7ivm")
				     (:file "dl7sqr")
				     (:file "dl7srt")
				     (:file "dl7svn")
				     (:file "dl7svx")
				     (:file "dl7tvm")
				     (:file "dl7vml")
				     (:file "dmdc")
			  #-allegro  (:file "dparck")
				     (:file "dq7adr")
				     (:file "dq7rsh")
			             (:file "drglgb") ; called by dflfb
				     (:file "drldst")
				     (:file "ds7bqn")
				     (:file "ds7dmp")
				     (:file "ds7ipr")
				     (:file "ds7lup")
				     (:file "ds7lvm")
				     (:file "dv2axy")
				     (:file "dv2nrm")
				     (:file "dv7cpy")
				     (:file "dv7dfl")
				     (:file "dv7ipr")
				     (:file "dv7scl")
				     (:file "dv7scp")
				     (:file "dv7shf")
				     (:file "dv7vmp")
				     (:file "i7copy")
				     (:file "i7pnvr")
				     (:file "i7shft")
				     (:file "stopx")))
	       (:module "misc"
			:depends-on ("main" "f2cl" "cvode" "717")
			:serial T
			:pathname ""
			:components ((:file "rk")
				     (:file "pe_random")
				     (:file "pe_717"))
			)))