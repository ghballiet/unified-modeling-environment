;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DL7TSQ|
 (|FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|A| |FORTRAN-TO-LISP|::|L|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|N|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|L| |FORTRAN-TO-LISP|::|A|))
 (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
  ((|FORTRAN-TO-LISP|::|A| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|A-%DATA%| |FORTRAN-TO-LISP|::|A-%OFFSET%|)
   (|FORTRAN-TO-LISP|::|L| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|L-%DATA%| |FORTRAN-TO-LISP|::|L-%OFFSET%|))
  (|COMMON-LISP|::|PROG|
   ((|FORTRAN-TO-LISP|::|LII| #1=0.0d0) (|FORTRAN-TO-LISP|::|LJ| #1#)
    (|FORTRAN-TO-LISP|::|I| 0.) (|FORTRAN-TO-LISP|::|II| 0.)
    (|FORTRAN-TO-LISP|::|IIM1| 0.) (|FORTRAN-TO-LISP|::|I1| 0.)
    (|FORTRAN-TO-LISP|::|J| 0.) (|FORTRAN-TO-LISP|::|K| 0.)
    (|FORTRAN-TO-LISP|::|M| 0.))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
     |FORTRAN-TO-LISP|::|LJ| |FORTRAN-TO-LISP|::|LII|)
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|M|
     |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I1|
     |FORTRAN-TO-LISP|::|IIM1| |FORTRAN-TO-LISP|::|II| |FORTRAN-TO-LISP|::|I|))
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|II| 0.)
   (|F2CL-LIB|::|FDO|
    (|FORTRAN-TO-LISP|::|I| 1.
     (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
    ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|N|)
     |COMMON-LISP|::|NIL|)
    (|COMMON-LISP|::|TAGBODY|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|I1|
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|II| 1.))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|II|
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|II| |FORTRAN-TO-LISP|::|I|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|M| 1.)
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|I| 1.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL30|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IIM1|
      (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|II| 1.))
     (|F2CL-LIB|::|FDO|
      (|FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I1|
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| 1.))
      ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|IIM1|)
       |COMMON-LISP|::|NIL|)
      (|COMMON-LISP|::|TAGBODY|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|LJ|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
         (|FORTRAN-TO-LISP|::|J|) ((1. 1.)) |FORTRAN-TO-LISP|::|L-%OFFSET%|))
       (|F2CL-LIB|::|FDO|
        (|FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|I1|
         (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|K| 1.))
        ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|J|)
         |COMMON-LISP|::|NIL|)
        (|COMMON-LISP|::|TAGBODY|
         (|COMMON-LISP|::|SETF|
          (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|A-%DATA%|
           (|FORTRAN-TO-LISP|::|M|) ((1. 1.)) |FORTRAN-TO-LISP|::|A-%OFFSET%|)
          (|COMMON-LISP|::|+|
           (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|A-%DATA%|
            (|FORTRAN-TO-LISP|::|M|) ((1. 1.)) |FORTRAN-TO-LISP|::|A-%OFFSET%|)
           (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|LJ|
            (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
             (|FORTRAN-TO-LISP|::|K|) ((1. 1.))
             |FORTRAN-TO-LISP|::|L-%OFFSET%|))))
         (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|M|
          (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|M| 1.))
         |FORTRAN-TO-LISP|::|LABEL10|))
       |FORTRAN-TO-LISP|::|LABEL20|))
     |FORTRAN-TO-LISP|::|LABEL30|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|LII|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
       (|FORTRAN-TO-LISP|::|II|) ((1. 1.)) |FORTRAN-TO-LISP|::|L-%OFFSET%|))
     (|F2CL-LIB|::|FDO|
      (|FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I1|
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| 1.))
      ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|II|)
       |COMMON-LISP|::|NIL|)
      (|COMMON-LISP|::|TAGBODY| |FORTRAN-TO-LISP|::|LABEL40|
       (|COMMON-LISP|::|SETF|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|A-%DATA%|
         (|FORTRAN-TO-LISP|::|J|) ((1. 1.)) |FORTRAN-TO-LISP|::|A-%OFFSET%|)
        (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|LII|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
          (|FORTRAN-TO-LISP|::|J|) ((1. 1.))
          |FORTRAN-TO-LISP|::|L-%OFFSET%|)))))
     |FORTRAN-TO-LISP|::|LABEL50|))
   |FORTRAN-TO-LISP|::|LABEL999|
   (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
   |FORTRAN-TO-LISP|::|END_LABEL|
   (|COMMON-LISP|::|RETURN|
    (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
     |COMMON-LISP|::|NIL|)))))

