;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DS7LVM|
 (|FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|Y| |FORTRAN-TO-LISP|::|S|
  |FORTRAN-TO-LISP|::|X|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|P|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|Y|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|S|))

;(incf *ds7lvm*)

 (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
  ((|FORTRAN-TO-LISP|::|S| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|S-%DATA%| |FORTRAN-TO-LISP|::|S-%OFFSET%|)
   (|FORTRAN-TO-LISP|::|Y| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|Y-%DATA%| |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
   (|FORTRAN-TO-LISP|::|X| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|X-%DATA%| |FORTRAN-TO-LISP|::|X-%OFFSET%|))
  (|COMMON-LISP|::|PROG|
   ((|FORTRAN-TO-LISP|::|XI| 0.0d0) (|FORTRAN-TO-LISP|::|I| 0.)
    (|FORTRAN-TO-LISP|::|IM1| 0.) (|FORTRAN-TO-LISP|::|J| 0.)
    (|FORTRAN-TO-LISP|::|K| 0.))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
     |FORTRAN-TO-LISP|::|XI|)
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|K|
     |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|IM1| |FORTRAN-TO-LISP|::|I|))
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J| 1.)
   (|F2CL-LIB|::|FDO|
    (|FORTRAN-TO-LISP|::|I| 1.
     (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
    ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
     |COMMON-LISP|::|NIL|)
    (|COMMON-LISP|::|TAGBODY|
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
       (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
       |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
      (|FORTRAN-TO-LISP|::|DD7TPR| |FORTRAN-TO-LISP|::|I|
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|S|
        |COMMON-LISP|::|DOUBLE-FLOAT| (|FORTRAN-TO-LISP|::|J|) ((1. 1.)))
       |FORTRAN-TO-LISP|::|X|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J|
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I|))
     |FORTRAN-TO-LISP|::|LABEL10|))
   (|COMMON-LISP|::|IF| (|COMMON-LISP|::|<=| |FORTRAN-TO-LISP|::|P| 1.)
    (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J| 1.)
   (|F2CL-LIB|::|FDO|
    (|FORTRAN-TO-LISP|::|I| 2.
     (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
    ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
     |COMMON-LISP|::|NIL|)
    (|COMMON-LISP|::|TAGBODY|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|XI|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
       (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
       |FORTRAN-TO-LISP|::|X-%OFFSET%|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IM1|
      (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|I| 1.))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J|
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| 1.))
     (|F2CL-LIB|::|FDO|
      (|FORTRAN-TO-LISP|::|K| 1.
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|K| 1.))
      ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|IM1|)
       |COMMON-LISP|::|NIL|)
      (|COMMON-LISP|::|TAGBODY|
       (|COMMON-LISP|::|SETF|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
         (|FORTRAN-TO-LISP|::|K|) ((1. |FORTRAN-TO-LISP|::|P|))
         |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
        (|COMMON-LISP|::|+|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|Y-%DATA%|
          (|FORTRAN-TO-LISP|::|K|) ((1. |FORTRAN-TO-LISP|::|P|))
          |FORTRAN-TO-LISP|::|Y-%OFFSET%|)
         (|COMMON-LISP|::|*|
          (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|S-%DATA%|
           (|FORTRAN-TO-LISP|::|J|) ((1. 1.)) |FORTRAN-TO-LISP|::|S-%OFFSET%|)
          |FORTRAN-TO-LISP|::|XI|)))
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J|
        (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| 1.))
       |FORTRAN-TO-LISP|::|LABEL30|))
     |FORTRAN-TO-LISP|::|LABEL40|))
   |FORTRAN-TO-LISP|::|LABEL999|
   (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
   |FORTRAN-TO-LISP|::|END_LABEL|
   (|COMMON-LISP|::|RETURN|
    (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
     |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|)))))
