;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DV7SHF|
 (|FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|X|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|K|
   |FORTRAN-TO-LISP|::|N|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|X|))

;(incf *dv7shf*)

 (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
  ((|FORTRAN-TO-LISP|::|X| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|X-%DATA%| |FORTRAN-TO-LISP|::|X-%OFFSET%|))
  (|COMMON-LISP|::|PROG|
   ((|FORTRAN-TO-LISP|::|T$| 0.0d0) (|FORTRAN-TO-LISP|::|I| 0.)
    (|FORTRAN-TO-LISP|::|NM1| 0.))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
     |FORTRAN-TO-LISP|::|T$|)
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|NM1|
     |FORTRAN-TO-LISP|::|I|))
   (|COMMON-LISP|::|IF|
    (|COMMON-LISP|::|>=| |FORTRAN-TO-LISP|::|K| |FORTRAN-TO-LISP|::|N|)
    (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NM1|
    (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|N| 1.))
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
    (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%| (|FORTRAN-TO-LISP|::|K|)
     ((1. |FORTRAN-TO-LISP|::|N|)) |FORTRAN-TO-LISP|::|X-%OFFSET%|))
   (|F2CL-LIB|::|FDO|
    (|FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|K|
     (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
    ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|NM1|)
     |COMMON-LISP|::|NIL|)
    (|COMMON-LISP|::|TAGBODY| |FORTRAN-TO-LISP|::|LABEL10|
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
       (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
       |FORTRAN-TO-LISP|::|X-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
       ((|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
       ((1. |FORTRAN-TO-LISP|::|N|)) |FORTRAN-TO-LISP|::|X-%OFFSET%|))))
   (|COMMON-LISP|::|SETF|
    (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%| (|FORTRAN-TO-LISP|::|N|)
     ((1. |FORTRAN-TO-LISP|::|N|)) |FORTRAN-TO-LISP|::|X-%OFFSET%|)
    |FORTRAN-TO-LISP|::|T$|)
   |FORTRAN-TO-LISP|::|LABEL999|
   (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
   |FORTRAN-TO-LISP|::|END_LABEL|
   (|COMMON-LISP|::|RETURN|
    (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
     |COMMON-LISP|::|NIL|)))))

