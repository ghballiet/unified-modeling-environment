;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|I7COPY|
 (|FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|Y| |FORTRAN-TO-LISP|::|X|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|P|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |F2CL-LIB|::|INTEGER4| (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|Y|))

;(incf *i7copy*)

 (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
  ((|FORTRAN-TO-LISP|::|Y| |F2CL-LIB|::|INTEGER4| |FORTRAN-TO-LISP|::|Y-%DATA%|
    |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
   (|FORTRAN-TO-LISP|::|X| |F2CL-LIB|::|INTEGER4| |FORTRAN-TO-LISP|::|X-%DATA%|
    |FORTRAN-TO-LISP|::|X-%OFFSET%|))
  (|COMMON-LISP|::|PROG| ((|FORTRAN-TO-LISP|::|I| 0.))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|I|))
   (|F2CL-LIB|::|FDO|
    (|FORTRAN-TO-LISP|::|I| 1.
     (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
    ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
     |COMMON-LISP|::|NIL|)
    (|COMMON-LISP|::|TAGBODY| |FORTRAN-TO-LISP|::|LABEL10|
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
       (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
       |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
       (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
       |FORTRAN-TO-LISP|::|X-%OFFSET%|))))
   |FORTRAN-TO-LISP|::|LABEL999|
   (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
   |FORTRAN-TO-LISP|::|END_LABEL|
   (|COMMON-LISP|::|RETURN|
    (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
     |COMMON-LISP|::|NIL|)))))
