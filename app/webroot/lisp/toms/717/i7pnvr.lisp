;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|I7PNVR|
 (|FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|Y|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|N|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |F2CL-LIB|::|INTEGER4| (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|Y| |FORTRAN-TO-LISP|::|X|))

;(incf *i7pnvr*)

 (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
  ((|FORTRAN-TO-LISP|::|X| |F2CL-LIB|::|INTEGER4| |FORTRAN-TO-LISP|::|X-%DATA%|
    |FORTRAN-TO-LISP|::|X-%OFFSET%|)
   (|FORTRAN-TO-LISP|::|Y| |F2CL-LIB|::|INTEGER4| |FORTRAN-TO-LISP|::|Y-%DATA%|
    |FORTRAN-TO-LISP|::|Y-%OFFSET%|))
  (|COMMON-LISP|::|PROG|
   ((|FORTRAN-TO-LISP|::|I| 0.) (|FORTRAN-TO-LISP|::|J| 0.))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|J|
     |FORTRAN-TO-LISP|::|I|))
   (|F2CL-LIB|::|FDO|
    (|FORTRAN-TO-LISP|::|I| 1.
     (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
    ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|N|)
     |COMMON-LISP|::|NIL|)
    (|COMMON-LISP|::|TAGBODY|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
       (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
       |FORTRAN-TO-LISP|::|Y-%OFFSET%|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
       (|FORTRAN-TO-LISP|::|J|) ((1. |FORTRAN-TO-LISP|::|N|))
       |FORTRAN-TO-LISP|::|X-%OFFSET%|)
      |FORTRAN-TO-LISP|::|I|)
     |FORTRAN-TO-LISP|::|LABEL10|))
   |FORTRAN-TO-LISP|::|LABEL999|
   (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
   |FORTRAN-TO-LISP|::|END_LABEL|
   (|COMMON-LISP|::|RETURN|
    (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
     |COMMON-LISP|::|NIL|)))))

