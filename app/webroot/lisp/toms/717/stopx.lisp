;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|STOPX|
 (|FORTRAN-TO-LISP|::|IDUMMY|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|IDUMMY|)
  (|COMMON-LISP|::|IGNORE| |FORTRAN-TO-LISP|::|IDUMMY|))
 (|COMMON-LISP|::|PROG| ((|FORTRAN-TO-LISP|::|STOPX| |COMMON-LISP|::|NIL|))
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| |F2CL-LIB|::|LOGICAL| |FORTRAN-TO-LISP|::|STOPX|))
  (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|STOPX| |F2CL-LIB|::|%FALSE%|)
  (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
  |FORTRAN-TO-LISP|::|END_LABEL|
  (|COMMON-LISP|::|RETURN|
   (|COMMON-LISP|::|VALUES| |FORTRAN-TO-LISP|::|STOPX| |COMMON-LISP|::|NIL|))))

