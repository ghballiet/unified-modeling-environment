;; runs scipm

(load "~/.emacs.d/quicklisp/setup.lisp") ;; loads quicklisp
(ql:quickload :mt19937)			 ;; loads MT19937
(ql:quickload :bordeaux-threads)
(load "sb-callback/sb-callback.asd")
;; push non-pe-sim in order to use my version of pe_717
(push :NON-PE-SIM *features*)
(asdf::compile-system :scipm :force t)
;; (asdf::compile-system :scipm)
(require :scipm)
;; (run-scipm-random "pp-lynx-instance" :nmodels 1)

;; ===================================================================
;; attempt to define a model
;; ===================================================================		    