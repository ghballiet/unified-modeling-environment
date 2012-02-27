;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DL7IVM|
  (|FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|L|
   |FORTRAN-TO-LISP|::|Y|)
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|N|)
   (|COMMON-LISP|::|TYPE|
    (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
    |FORTRAN-TO-LISP|::|Y| |FORTRAN-TO-LISP|::|X|)
   (|COMMON-LISP|::|TYPE|
    (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
    |FORTRAN-TO-LISP|::|L|))
(|COMMON-LISP|::|LET*| ((|FORTRAN-TO-LISP|::|ZERO| #1=0.0d0))
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT| #1# #1#)
   |FORTRAN-TO-LISP|::|ZERO|))
 
;(incf *dl7ivm*)

  (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
   ((|FORTRAN-TO-LISP|::|L| |COMMON-LISP|::|DOUBLE-FLOAT|
     |FORTRAN-TO-LISP|::|L-%DATA%| |FORTRAN-TO-LISP|::|L-%OFFSET%|)
    (|FORTRAN-TO-LISP|::|X| |COMMON-LISP|::|DOUBLE-FLOAT|
     |FORTRAN-TO-LISP|::|X-%DATA%| |FORTRAN-TO-LISP|::|X-%OFFSET%|)
    (|FORTRAN-TO-LISP|::|Y| |COMMON-LISP|::|DOUBLE-FLOAT|
     |FORTRAN-TO-LISP|::|Y-%DATA%| |FORTRAN-TO-LISP|::|Y-%OFFSET%|))
   (|COMMON-LISP|::|PROG|
    ((|FORTRAN-TO-LISP|::|T$| #1#) (|FORTRAN-TO-LISP|::|I| 0.)
     (|FORTRAN-TO-LISP|::|J| 0.) (|FORTRAN-TO-LISP|::|K| 0.))
    (|COMMON-LISP|::|DECLARE|
     (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
      |FORTRAN-TO-LISP|::|T$|)
     (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|K|
      |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I|))
    (|F2CL-LIB|::|FDO|
     (|FORTRAN-TO-LISP|::|K| 1.
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|K| 1.))
     ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|N|)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|TAGBODY|
      (|COMMON-LISP|::|IF|
       (|COMMON-LISP|::|/=|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
         (|FORTRAN-TO-LISP|::|K|) ((1. |FORTRAN-TO-LISP|::|N|))
         |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
        |FORTRAN-TO-LISP|::|ZERO|)
       (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL20|))
      (|COMMON-LISP|::|SETF|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
        (|FORTRAN-TO-LISP|::|K|) ((1. |FORTRAN-TO-LISP|::|N|))
        |FORTRAN-TO-LISP|::|X-%OFFSET%|)
       |FORTRAN-TO-LISP|::|ZERO|)
      |FORTRAN-TO-LISP|::|LABEL10|))
    (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
    |FORTRAN-TO-LISP|::|LABEL20|
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J|
     (|COMMON-LISP|::|THE| |F2CL-LIB|::|INTEGER4|
      (|COMMON-LISP|::|TRUNCATE|
       (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|K|
        (|COMMON-LISP|::|+| |FORTRAN-TO-LISP|::|K| 1.))
       2.)))
    (|COMMON-LISP|::|SETF|
     (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%| (|FORTRAN-TO-LISP|::|K|)
      ((1. |FORTRAN-TO-LISP|::|N|)) |FORTRAN-TO-LISP|::|X-%OFFSET%|)
     (|COMMON-LISP|::|/|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
       (|FORTRAN-TO-LISP|::|K|) ((1. |FORTRAN-TO-LISP|::|N|))
       |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
       (|FORTRAN-TO-LISP|::|J|) ((1. 1.)) |FORTRAN-TO-LISP|::|L-%OFFSET%|)))
    (|COMMON-LISP|::|IF|
     (|COMMON-LISP|::|>=| |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|N|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|K|
     (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|K| 1.))
    (|F2CL-LIB|::|FDO|
     (|FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|K|
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
     ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|N|)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|TAGBODY|
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
       (|FORTRAN-TO-LISP|::|DD7TPR|
        (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|I| 1.)
        (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|L|
         |COMMON-LISP|::|DOUBLE-FLOAT|
         ((|COMMON-LISP|::|+| |FORTRAN-TO-LISP|::|J| 1.)) ((1. 1.)))
        |FORTRAN-TO-LISP|::|X|))
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J|
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I|))
      (|COMMON-LISP|::|SETF|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
        (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
        |FORTRAN-TO-LISP|::|X-%OFFSET%|)
       (|COMMON-LISP|::|/|
        (|COMMON-LISP|::|-|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
          (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
          |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
         |FORTRAN-TO-LISP|::|T$|)
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
         (|FORTRAN-TO-LISP|::|J|) ((1. 1.)) |FORTRAN-TO-LISP|::|L-%OFFSET%|)))
      |FORTRAN-TO-LISP|::|LABEL30|))
    |FORTRAN-TO-LISP|::|LABEL999|
    (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
    |FORTRAN-TO-LISP|::|END_LABEL|
    (|COMMON-LISP|::|RETURN|
     (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
      |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|))))))

