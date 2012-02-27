(defpackage :callback
  (:use :cl :sb-ext :sb-alien :sb-assem :asdf)
  (:export :defcallback 
	   :callback))

(in-package :callback)

(defsystem :sb-callback
  :version "0.9.0"
  :license "Isle"
  :serial T
  :pathname ""
  :components ((:file "callback")))
