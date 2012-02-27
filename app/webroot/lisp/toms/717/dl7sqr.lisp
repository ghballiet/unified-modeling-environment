;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DL7SQR|
 (|FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|A| |FORTRAN-TO-LISP|::|L|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|N|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|L| |FORTRAN-TO-LISP|::|A|))

;(incf *dl7sqr*)

 (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
  ((|FORTRAN-TO-LISP|::|A| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|A-%DATA%| |FORTRAN-TO-LISP|::|A-%OFFSET%|)
   (|FORTRAN-TO-LISP|::|L| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|L-%DATA%| |FORTRAN-TO-LISP|::|L-%OFFSET%|))
  (|COMMON-LISP|::|PROG|
   ((|FORTRAN-TO-LISP|::|T$| #1=0.0d0) (|FORTRAN-TO-LISP|::|I| 0.)
    (|FORTRAN-TO-LISP|::|II| 0.) (|FORTRAN-TO-LISP|::|IJ| 0.)
    (|FORTRAN-TO-LISP|::|IK| 0.) (|FORTRAN-TO-LISP|::|IP1| 0.)
    (|FORTRAN-TO-LISP|::|I0| 0.) (|FORTRAN-TO-LISP|::|J| 0.)
    (|FORTRAN-TO-LISP|::|JJ| 0.) (|FORTRAN-TO-LISP|::|JK| 0.)
    (|FORTRAN-TO-LISP|::|J0| 0.) (|FORTRAN-TO-LISP|::|K| 0.)
    (|FORTRAN-TO-LISP|::|NP1| 0.))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
     |FORTRAN-TO-LISP|::|T$|)
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|NP1|
     |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|J0| |FORTRAN-TO-LISP|::|JK|
     |FORTRAN-TO-LISP|::|JJ| |FORTRAN-TO-LISP|::|J| |FORTRAN-TO-LISP|::|I0|
     |FORTRAN-TO-LISP|::|IP1| |FORTRAN-TO-LISP|::|IK| |FORTRAN-TO-LISP|::|IJ|
     |FORTRAN-TO-LISP|::|II| |FORTRAN-TO-LISP|::|I|))
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NP1|
    (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|N| 1.))
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|I0|
    (|COMMON-LISP|::|THE| |F2CL-LIB|::|INTEGER4|
     (|COMMON-LISP|::|TRUNCATE|
      (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|N|
       (|COMMON-LISP|::|+| |FORTRAN-TO-LISP|::|N| 1.))
      2.)))
   (|F2CL-LIB|::|FDO|
    (|FORTRAN-TO-LISP|::|II| 1.
     (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|II| 1.))
    ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|II| |FORTRAN-TO-LISP|::|N|)
     |COMMON-LISP|::|NIL|)
    (|COMMON-LISP|::|TAGBODY|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|I|
      (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|NP1| |FORTRAN-TO-LISP|::|II|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IP1|
      (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|I0|
      (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|I0| |FORTRAN-TO-LISP|::|I|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J0|
      (|COMMON-LISP|::|THE| |F2CL-LIB|::|INTEGER4|
       (|COMMON-LISP|::|TRUNCATE|
        (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|I|
         (|COMMON-LISP|::|+| |FORTRAN-TO-LISP|::|I| 1.))
        2.)))
     (|F2CL-LIB|::|FDO|
      (|FORTRAN-TO-LISP|::|JJ| 1.
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|JJ| 1.))
      ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|JJ| |FORTRAN-TO-LISP|::|I|)
       |COMMON-LISP|::|NIL|)
      (|COMMON-LISP|::|TAGBODY|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J|
        (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|IP1|
         |FORTRAN-TO-LISP|::|JJ|))
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|J0|
        (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|J0| |FORTRAN-TO-LISP|::|J|))
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$| #1#)
       (|F2CL-LIB|::|FDO|
        (|FORTRAN-TO-LISP|::|K| 1.
         (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|K| 1.))
        ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|J|)
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
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IJ|
        (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I0| |FORTRAN-TO-LISP|::|J|))
       (|COMMON-LISP|::|SETF|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|A-%DATA%|
         (|FORTRAN-TO-LISP|::|IJ|) ((1. 1.)) |FORTRAN-TO-LISP|::|A-%OFFSET%|)
        |FORTRAN-TO-LISP|::|T$|)
       |FORTRAN-TO-LISP|::|LABEL20|))
     |FORTRAN-TO-LISP|::|LABEL30|))
   |FORTRAN-TO-LISP|::|LABEL999|
   (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
   |FORTRAN-TO-LISP|::|END_LABEL|
   (|COMMON-LISP|::|RETURN|
    (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
     |COMMON-LISP|::|NIL|)))))

