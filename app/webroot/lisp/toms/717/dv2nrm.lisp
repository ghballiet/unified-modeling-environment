;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)

(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DV2NRM|
 (|FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|X|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|P|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT|
    (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|X|))
 (|COMMON-LISP|::|LET*|
  ((|FORTRAN-TO-LISP|::|ONE| #1=1.0d0) (|FORTRAN-TO-LISP|::|ZERO| #2=0.0d0))
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT| #1# #1#) |FORTRAN-TO-LISP|::|ONE|)
   (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT| #2# #2#) |FORTRAN-TO-LISP|::|ZERO|))
  (|COMMON-LISP|::|LET| ((|FORTRAN-TO-LISP|::|SQTETA| #2#))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|) |FORTRAN-TO-LISP|::|SQTETA|))

;(incf *dv2nrm*)

   (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
    ((|FORTRAN-TO-LISP|::|X| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|X-%DATA%| |FORTRAN-TO-LISP|::|X-%OFFSET%|))
    (|COMMON-LISP|::|PROG|
     ((|FORTRAN-TO-LISP|::|R| #2#) (|FORTRAN-TO-LISP|::|SCALE| #2#)
      (|FORTRAN-TO-LISP|::|XI| #2#) (|FORTRAN-TO-LISP|::|I| 0.)
      (|FORTRAN-TO-LISP|::|J| 0.) (|FORTRAN-TO-LISP|::|DV2NRM| #2#)
      (|FORTRAN-TO-LISP|::|T$| #2#))
     (|COMMON-LISP|::|DECLARE|
      (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
       |FORTRAN-TO-LISP|::|T$| |FORTRAN-TO-LISP|::|DV2NRM|
       |FORTRAN-TO-LISP|::|XI| |FORTRAN-TO-LISP|::|SCALE|
       |FORTRAN-TO-LISP|::|R|)
      (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|J|
       |FORTRAN-TO-LISP|::|I|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|P| 0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL10|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DV2NRM|
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
     |FORTRAN-TO-LISP|::|LABEL10|
     (|F2CL-LIB|::|FDO|
      (|FORTRAN-TO-LISP|::|I| 1.
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
      ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
       |COMMON-LISP|::|NIL|)
      (|COMMON-LISP|::|TAGBODY|
       (|COMMON-LISP|::|IF|
        (|COMMON-LISP|::|/=|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
          (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
          |FORTRAN-TO-LISP|::|X-%OFFSET%|)
         |FORTRAN-TO-LISP|::|ZERO|)
        (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL30|))
       |FORTRAN-TO-LISP|::|LABEL20|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DV2NRM|
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
     |FORTRAN-TO-LISP|::|LABEL30|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|SCALE|
      (|COMMON-LISP|::|ABS|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
        (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
        |FORTRAN-TO-LISP|::|X-%OFFSET%|)))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|<| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL40|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DV2NRM|
      |FORTRAN-TO-LISP|::|SCALE|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
     |FORTRAN-TO-LISP|::|LABEL40|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$| |FORTRAN-TO-LISP|::|ONE|)
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|SQTETA|
       |FORTRAN-TO-LISP|::|ZERO|)
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|SQTETA|
       (|FORTRAN-TO-LISP|::|DR7MDC| 2.)))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J|
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
     (|F2CL-LIB|::|FDO|
      (|FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|J|
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
      ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
       |COMMON-LISP|::|NIL|)
      (|COMMON-LISP|::|TAGBODY|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|XI|
        (|COMMON-LISP|::|ABS|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
          (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
          |FORTRAN-TO-LISP|::|X-%OFFSET%|)))
       (|COMMON-LISP|::|IF|
        (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|XI| |FORTRAN-TO-LISP|::|SCALE|)
        (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL50|))
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|R|
        (|COMMON-LISP|::|/| |FORTRAN-TO-LISP|::|XI|
         |FORTRAN-TO-LISP|::|SCALE|))
       (|COMMON-LISP|::|IF|
        (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|R| |FORTRAN-TO-LISP|::|SQTETA|)
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
         (|COMMON-LISP|::|+| |FORTRAN-TO-LISP|::|T$|
          (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|R| |FORTRAN-TO-LISP|::|R|))))
       (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL60|)
       |FORTRAN-TO-LISP|::|LABEL50|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|R|
        (|COMMON-LISP|::|/| |FORTRAN-TO-LISP|::|SCALE|
         |FORTRAN-TO-LISP|::|XI|))
       (|COMMON-LISP|::|IF|
        (|COMMON-LISP|::|<=| |FORTRAN-TO-LISP|::|R|
         |FORTRAN-TO-LISP|::|SQTETA|)
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|R|
         |FORTRAN-TO-LISP|::|ZERO|))
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
        (|COMMON-LISP|::|+| |FORTRAN-TO-LISP|::|ONE|
         (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|T$| |FORTRAN-TO-LISP|::|R|
          |FORTRAN-TO-LISP|::|R|)))
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|SCALE|
        |FORTRAN-TO-LISP|::|XI|)
       |FORTRAN-TO-LISP|::|LABEL60|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DV2NRM|
      (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|SCALE|
       (|F2CL-LIB|::|FSQRT| |FORTRAN-TO-LISP|::|T$|)))
     |FORTRAN-TO-LISP|::|LABEL999|
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
     |FORTRAN-TO-LISP|::|END_LABEL|
     (|COMMON-LISP|::|RETURN|
      (|COMMON-LISP|::|VALUES| |FORTRAN-TO-LISP|::|DV2NRM| |COMMON-LISP|::|NIL|
       |COMMON-LISP|::|NIL|)))))))

