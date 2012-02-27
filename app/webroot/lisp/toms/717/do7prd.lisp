;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


 (|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DO7PRD|
  (|FORTRAN-TO-LISP|::|L| |FORTRAN-TO-LISP|::|LS| |FORTRAN-TO-LISP|::|P|
   |FORTRAN-TO-LISP|::|S| |FORTRAN-TO-LISP|::|W| |FORTRAN-TO-LISP|::|Y|
   |FORTRAN-TO-LISP|::|Z|)
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|P|
    |FORTRAN-TO-LISP|::|LS| |FORTRAN-TO-LISP|::|L|)
   (|COMMON-LISP|::|TYPE|
    (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
    |FORTRAN-TO-LISP|::|Z| |FORTRAN-TO-LISP|::|Y| |FORTRAN-TO-LISP|::|W|
    |FORTRAN-TO-LISP|::|S|)
   (|COMMON-LISP|::|IGNORABLE| |FORTRAN-TO-LISP|::|LS|))
  (|COMMON-LISP|::|LET| ((|FORTRAN-TO-LISP|::|ZERO| #1=0.0d0))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|) |FORTRAN-TO-LISP|::|ZERO|))
    (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
     ((|FORTRAN-TO-LISP|::|S| |COMMON-LISP|::|DOUBLE-FLOAT|
       |FORTRAN-TO-LISP|::|S-%DATA%| |FORTRAN-TO-LISP|::|S-%OFFSET%|)
      (|FORTRAN-TO-LISP|::|W| |COMMON-LISP|::|DOUBLE-FLOAT|
       |FORTRAN-TO-LISP|::|W-%DATA%| |FORTRAN-TO-LISP|::|W-%OFFSET%|)
      (|FORTRAN-TO-LISP|::|Y| |COMMON-LISP|::|DOUBLE-FLOAT|
       |FORTRAN-TO-LISP|::|Y-%DATA%| |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
      (|FORTRAN-TO-LISP|::|Z| |COMMON-LISP|::|DOUBLE-FLOAT|
       |FORTRAN-TO-LISP|::|Z-%DATA%| |FORTRAN-TO-LISP|::|Z-%OFFSET%|))
     (|COMMON-LISP|::|PROG|
      ((|FORTRAN-TO-LISP|::|WK| #1#) (|FORTRAN-TO-LISP|::|YI| #1#)
       (|FORTRAN-TO-LISP|::|I| 0.) (|FORTRAN-TO-LISP|::|J| 0.)
       (|FORTRAN-TO-LISP|::|K| 0.) (|FORTRAN-TO-LISP|::|M| 0.))
      (|COMMON-LISP|::|DECLARE|
       (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
	|FORTRAN-TO-LISP|::|YI| |FORTRAN-TO-LISP|::|WK|)
       (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|M|
        |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I|))
      (|F2CL-LIB|::|FDO|
       (|FORTRAN-TO-LISP|::|K| 1.
        (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|K| 1.))
       ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|L|)
        |COMMON-LISP|::|NIL|)
       (|COMMON-LISP|::|TAGBODY|
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|WK|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|W-%DATA%|
          (|FORTRAN-TO-LISP|::|K|) ((1. |FORTRAN-TO-LISP|::|L|))
          |FORTRAN-TO-LISP|::|W-%OFFSET%|))
        (|COMMON-LISP|::|IF|
         (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|WK| |FORTRAN-TO-LISP|::|ZERO|)
         (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL30|))
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|M| 1.)
        (|F2CL-LIB|::|FDO|
         (|FORTRAN-TO-LISP|::|I| 1.
          (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
         ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
          |COMMON-LISP|::|NIL|)
         (|COMMON-LISP|::|TAGBODY|
          (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|YI|
           (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|WK|
            (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
             (|FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|K|)
             ((1. |FORTRAN-TO-LISP|::|P|) (1. |FORTRAN-TO-LISP|::|L|))
             |FORTRAN-TO-LISP|::|Y-%OFFSET%|)))
          (|F2CL-LIB|::|FDO|
           (|FORTRAN-TO-LISP|::|J| 1.
            (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| 1.))
           ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I|)
            |COMMON-LISP|::|NIL|)
           (|COMMON-LISP|::|TAGBODY|
            (|COMMON-LISP|::|SETF|
             (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|S-%DATA%|
              (|FORTRAN-TO-LISP|::|M|) ((1. |FORTRAN-TO-LISP|::|LS|))
              |FORTRAN-TO-LISP|::|S-%OFFSET%|)
             (|COMMON-LISP|::|+|
              (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|S-%DATA%|
               (|FORTRAN-TO-LISP|::|M|) ((1. |FORTRAN-TO-LISP|::|LS|))
               |FORTRAN-TO-LISP|::|S-%OFFSET%|)
              (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|YI|
               (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Z-%DATA%|
                (|FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|K|)
                ((1. |FORTRAN-TO-LISP|::|P|) (1. |FORTRAN-TO-LISP|::|L|))
                |FORTRAN-TO-LISP|::|Z-%OFFSET%|))))
            (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|M|
             (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|M| 1.))
            |FORTRAN-TO-LISP|::|LABEL10|))
          |FORTRAN-TO-LISP|::|LABEL20|))
        |FORTRAN-TO-LISP|::|LABEL30|))
      |FORTRAN-TO-LISP|::|LABEL999|
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
      |FORTRAN-TO-LISP|::|END_LABEL|
      (|COMMON-LISP|::|RETURN|
       (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
        |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
        |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|))))))
  
  