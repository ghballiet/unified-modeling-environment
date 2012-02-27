;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DL7SRT|
  (|FORTRAN-TO-LISP|::|N1| |FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|L|
   |FORTRAN-TO-LISP|::|A| |FORTRAN-TO-LISP|::|IRC|)
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|IRC|
    |FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|N1|)
   (|COMMON-LISP|::|TYPE|
    (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
    |FORTRAN-TO-LISP|::|A| |FORTRAN-TO-LISP|::|L|))
(|COMMON-LISP|::|LET*| ((|FORTRAN-TO-LISP|::|ZERO| #1=0.0d0))
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT| #1# #1#)
   |FORTRAN-TO-LISP|::|ZERO|))
 
;(incf *dl7srt*)

  (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
   ((|FORTRAN-TO-LISP|::|L| |COMMON-LISP|::|DOUBLE-FLOAT|
     |FORTRAN-TO-LISP|::|L-%DATA%| |FORTRAN-TO-LISP|::|L-%OFFSET%|)
    (|FORTRAN-TO-LISP|::|A| |COMMON-LISP|::|DOUBLE-FLOAT|
     |FORTRAN-TO-LISP|::|A-%DATA%| |FORTRAN-TO-LISP|::|A-%OFFSET%|))
   (|COMMON-LISP|::|PROG|
    ((|FORTRAN-TO-LISP|::|TD| #1#) (|FORTRAN-TO-LISP|::|I| 0.)
     (|FORTRAN-TO-LISP|::|IJ| 0.) (|FORTRAN-TO-LISP|::|IK| 0.)
     (|FORTRAN-TO-LISP|::|IM1| 0.) (|FORTRAN-TO-LISP|::|I0| 0.)
     (|FORTRAN-TO-LISP|::|J| 0.) (|FORTRAN-TO-LISP|::|JK| 0.)
     (|FORTRAN-TO-LISP|::|JM1| 0.) (|FORTRAN-TO-LISP|::|J0| 0.)
     (|FORTRAN-TO-LISP|::|K| 0.) (|FORTRAN-TO-LISP|::|T$| #1#))
    (|COMMON-LISP|::|DECLARE|
     (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
      |FORTRAN-TO-LISP|::|T$| |FORTRAN-TO-LISP|::|TD|)
     (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|K|
      |FORTRAN-TO-LISP|::|J0| |FORTRAN-TO-LISP|::|JM1| |FORTRAN-TO-LISP|::|JK|
      |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I0| |FORTRAN-TO-LISP|::|IM1|
      |FORTRAN-TO-LISP|::|IK| |FORTRAN-TO-LISP|::|IJ| |FORTRAN-TO-LISP|::|I|))
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|I0|
     (|COMMON-LISP|::|THE| |F2CL-LIB|::|INTEGER4|
      (|COMMON-LISP|::|TRUNCATE|
       (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|N1|
        (|COMMON-LISP|::|-| |FORTRAN-TO-LISP|::|N1| 1.))
       2.)))
    (|F2CL-LIB|::|FDO|
     (|FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|N1|
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
     ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|N|)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|TAGBODY|
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|TD| |FORTRAN-TO-LISP|::|ZERO|)
      (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|I| 1.)
       (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL40|))
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J0| 0.)
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IM1|
       (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|I| 1.))
      (|F2CL-LIB|::|FDO|
       (|FORTRAN-TO-LISP|::|J| 1.
        (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J| 1.))
       ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|IM1|)
        |COMMON-LISP|::|NIL|)
       (|COMMON-LISP|::|TAGBODY|
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
         |FORTRAN-TO-LISP|::|ZERO|)
        (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|J| 1.)
         (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL20|))
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|JM1|
         (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|J| 1.))
        (|F2CL-LIB|::|FDO|
         (|FORTRAN-TO-LISP|::|K| 1.
          (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|K| 1.))
         ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|JM1|)
          |COMMON-LISP|::|NIL|)
         (|COMMON-LISP|::|TAGBODY|
          (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IK|
           (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I0|
            |FORTRAN-TO-LISP|::|K|))
          (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|JK|
           (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J0|
            |FORTRAN-TO-LISP|::|K|))
          (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
           (|COMMON-LISP|::|+| |FORTRAN-TO-LISP|::|T$|
            (|COMMON-LISP|::|*|
             (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
              (|FORTRAN-TO-LISP|::|IK|) ((1. 1.))
              |FORTRAN-TO-LISP|::|L-%OFFSET%|)
             (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
              (|FORTRAN-TO-LISP|::|JK|) ((1. 1.))
              |FORTRAN-TO-LISP|::|L-%OFFSET%|))))
          |FORTRAN-TO-LISP|::|LABEL10|))
        |FORTRAN-TO-LISP|::|LABEL20|
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IJ|
         (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I0|
          |FORTRAN-TO-LISP|::|J|))
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J0|
         (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|J0|
          |FORTRAN-TO-LISP|::|J|))
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
         (|COMMON-LISP|::|/|
          (|COMMON-LISP|::|-|
           (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|A-%DATA%|
            (|FORTRAN-TO-LISP|::|IJ|) ((1. 1.))
            |FORTRAN-TO-LISP|::|A-%OFFSET%|)
           |FORTRAN-TO-LISP|::|T$|)
          (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
           (|FORTRAN-TO-LISP|::|J0|) ((1. 1.))
           |FORTRAN-TO-LISP|::|L-%OFFSET%|)))
        (|COMMON-LISP|::|SETF|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
          (|FORTRAN-TO-LISP|::|IJ|) ((1. 1.)) |FORTRAN-TO-LISP|::|L-%OFFSET%|)
         |FORTRAN-TO-LISP|::|T$|)
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|TD|
         (|COMMON-LISP|::|+| |FORTRAN-TO-LISP|::|TD|
          (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|T$|
           |FORTRAN-TO-LISP|::|T$|)))
        |FORTRAN-TO-LISP|::|LABEL30|))
      |FORTRAN-TO-LISP|::|LABEL40|
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|I0|
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I0| |FORTRAN-TO-LISP|::|I|))
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
       (|COMMON-LISP|::|-|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|A-%DATA%|
         (|FORTRAN-TO-LISP|::|I0|) ((1. 1.)) |FORTRAN-TO-LISP|::|A-%OFFSET%|)
        |FORTRAN-TO-LISP|::|TD|))
      (|COMMON-LISP|::|IF|
       (|COMMON-LISP|::|<=| |FORTRAN-TO-LISP|::|T$| |FORTRAN-TO-LISP|::|ZERO|)
       (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL60|))
      (|COMMON-LISP|::|SETF|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
        (|FORTRAN-TO-LISP|::|I0|) ((1. 1.)) |FORTRAN-TO-LISP|::|L-%OFFSET%|)
       (|F2CL-LIB|::|FSQRT| |FORTRAN-TO-LISP|::|T$|))
      |FORTRAN-TO-LISP|::|LABEL50|))
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IRC| 0.)
    (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
    |FORTRAN-TO-LISP|::|LABEL60|
    (|COMMON-LISP|::|SETF|
     (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|L-%DATA%|
      (|FORTRAN-TO-LISP|::|I0|) ((1. 1.)) |FORTRAN-TO-LISP|::|L-%OFFSET%|)
     |FORTRAN-TO-LISP|::|T$|)
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IRC| |FORTRAN-TO-LISP|::|I|)
    |FORTRAN-TO-LISP|::|LABEL999|
    (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
    |FORTRAN-TO-LISP|::|END_LABEL|
    (|COMMON-LISP|::|RETURN|
     (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
      |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |FORTRAN-TO-LISP|::|IRC|))))))

