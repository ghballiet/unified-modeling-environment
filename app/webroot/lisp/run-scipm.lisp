;; runs scipm

(load "quicklisp/setup.lisp")
(ql:quickload :mt19937)
(ql:quickload :bordeaux-threads)
(ql:quickload :yason)
(load "sb-callback/sb-callback.asd")

;; push non-pe-sim in order to use my version of pe_717
(push :NON-PE-SIM *features*)

;; (asdf::compile-system :scipm :force t)
;; (asdf::compile-system :scipm)
(require :scipm)

(sb-ext:save-lisp-and-die "sbcl.core")