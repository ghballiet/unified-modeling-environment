;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DS7DMP|
 (|FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|Y|
  |FORTRAN-TO-LISP|::|Z| |FORTRAN-TO-LISP|::|K|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|K|
   |FORTRAN-TO-LISP|::|N|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|Z| |FORTRAN-TO-LISP|::|Y| |FORTRAN-TO-LISP|::|X|))
 (|COMMON-LISP|::|LET| ((|FORTRAN-TO-LISP|::|ONE| 1.0d0))
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|) |FORTRAN-TO-LISP|::|ONE|))
 
;(incf *ds7dmp*)

  (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
   ((|FORTRAN-TO-LISP|::|X| |COMMON-LISP|::|DOUBLE-FLOAT|
     |FORTRAN-TO-LISP|::|X-%DATA%| |FORTRAN-TO-LISP|::|X-%OFFSET%|)
    (|FORTRAN-TO-LISP|::|Y| |COMMON-LISP|::|DOUBLE-FLOAT|
     |FORTRAN-TO-LISP|::|Y-%DATA%| |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
    (|FORTRAN-TO-LISP|::|Z| |COMMON-LISP|::|DOUBLE-FLOAT|
     |FORTRAN-TO-LISP|::|Z-%DATA%| |FORTRAN-TO-LISP|::|Z-%OFFSET%|))
   (|COMMON-LISP|::|PROG|
    ((|FORTRAN-TO-LISP|::|T$| 0.0d0) (|FORTRAN-TO-LISP|::|I| 0.)
     (|FORTRAN-TO-LISP|::|J| 0.) (|FORTRAN-TO-LISP|::|L| 0.))
    (|COMMON-LISP|::|DECLARE|
     (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
      |FORTRAN-TO-LISP|::|T$|)
     (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|L|
      |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I|))
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|L| 1.)
    (|COMMON-LISP|::|IF| (|COMMON-LISP|::|>=| |FORTRAN-TO-LISP|::|K| 0.)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL30|))
    (|F2CL-LIB|::|FDO|
     (|FORTRAN-TO-LISP|::|I| 1.
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
     ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|N|)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|TAGBODY|
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
       (|COMMON-LISP|::|/| |FORTRAN-TO-LISP|::|ONE|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Z-%DATA%|
         (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
         |FORTRAN-TO-LISP|::|Z-%OFFSET%|)))
      (|F2CL-LIB|::|FDO|
       (|FORTRAN-TO-LISP|::|J| 1.
        (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| 1.))
       ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I|)
        |COMMON-LISP|::|NIL|)
       (|COMMON-LISP|::|TAGBODY|
        (|COMMON-LISP|::|SETF|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
          (|FORTRAN-TO-LISP|::|L|) ((1. |COMMON-LISP|::|*|))
          |FORTRAN-TO-LISP|::|X-%OFFSET%|)
         (|COMMON-LISP|::|/|
          (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|T$|
           (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
            (|FORTRAN-TO-LISP|::|L|) ((1. |COMMON-LISP|::|*|))
            |FORTRAN-TO-LISP|::|Y-%OFFSET%|))
          (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Z-%DATA%|
           (|FORTRAN-TO-LISP|::|J|) ((1. |FORTRAN-TO-LISP|::|N|))
           |FORTRAN-TO-LISP|::|Z-%OFFSET%|)))
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|L|
         (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|L| 1.))
        |FORTRAN-TO-LISP|::|LABEL10|))
      |FORTRAN-TO-LISP|::|LABEL20|))
    (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
    |FORTRAN-TO-LISP|::|LABEL30|
    (|F2CL-LIB|::|FDO|
     (|FORTRAN-TO-LISP|::|I| 1.
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
     ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|N|)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|TAGBODY|
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Z-%DATA%|
        (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
        |FORTRAN-TO-LISP|::|Z-%OFFSET%|))
      (|F2CL-LIB|::|FDO|
       (|FORTRAN-TO-LISP|::|J| 1.
        (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| 1.))
       ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I|)
        |COMMON-LISP|::|NIL|)
       (|COMMON-LISP|::|TAGBODY|
        (|COMMON-LISP|::|SETF|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
          (|FORTRAN-TO-LISP|::|L|) ((1. |COMMON-LISP|::|*|))
          |FORTRAN-TO-LISP|::|X-%OFFSET%|)
         (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|T$|
          (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
           (|FORTRAN-TO-LISP|::|L|) ((1. |COMMON-LISP|::|*|))
           |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
          (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Z-%DATA%|
           (|FORTRAN-TO-LISP|::|J|) ((1. |FORTRAN-TO-LISP|::|N|))
           |FORTRAN-TO-LISP|::|Z-%OFFSET%|)))
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|L|
         (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|L| 1.))
        |FORTRAN-TO-LISP|::|LABEL40|))
      |FORTRAN-TO-LISP|::|LABEL50|))
    |FORTRAN-TO-LISP|::|LABEL999|
    (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
    |FORTRAN-TO-LISP|::|END_LABEL|
    (|COMMON-LISP|::|RETURN|
     (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
      |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|))))))

