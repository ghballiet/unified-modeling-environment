;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DH2RFA|
 (|FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|A| |FORTRAN-TO-LISP|::|B|
  |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|Y| |FORTRAN-TO-LISP|::|Z|)
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|N|)
  (|COMMON-LISP|::|TYPE|
   (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
   |FORTRAN-TO-LISP|::|B| |FORTRAN-TO-LISP|::|A|)
  (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|) |FORTRAN-TO-LISP|::|Z|
   |FORTRAN-TO-LISP|::|Y| |FORTRAN-TO-LISP|::|X|))

;(incf *dh2rfa*)

 (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
  ((|FORTRAN-TO-LISP|::|A| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|A-%DATA%| |FORTRAN-TO-LISP|::|A-%OFFSET%|)
   (|FORTRAN-TO-LISP|::|B| |COMMON-LISP|::|DOUBLE-FLOAT|
    |FORTRAN-TO-LISP|::|B-%DATA%| |FORTRAN-TO-LISP|::|B-%OFFSET%|))
  (|COMMON-LISP|::|PROG|
   ((|FORTRAN-TO-LISP|::|T$| 0.0d0) (|FORTRAN-TO-LISP|::|I| 0.))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
     |FORTRAN-TO-LISP|::|T$|)
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|I|))
   (|F2CL-LIB|::|FDO|
    (|FORTRAN-TO-LISP|::|I| 1.
     (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
    ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|N|)
     |COMMON-LISP|::|NIL|)
    (|COMMON-LISP|::|TAGBODY|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
      (|COMMON-LISP|::|+|
       (|COMMON-LISP|::|*|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|A-%DATA%|
         (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
         |FORTRAN-TO-LISP|::|A-%OFFSET%|)
        |FORTRAN-TO-LISP|::|X|)
       (|COMMON-LISP|::|*|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|B-%DATA%|
         (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
         |FORTRAN-TO-LISP|::|B-%OFFSET%|)
        |FORTRAN-TO-LISP|::|Y|)))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|A-%DATA%|
       (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
       |FORTRAN-TO-LISP|::|A-%OFFSET%|)
      (|COMMON-LISP|::|+|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|A-%DATA%|
        (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
        |FORTRAN-TO-LISP|::|A-%OFFSET%|)
       |FORTRAN-TO-LISP|::|T$|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|B-%DATA%|
       (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
       |FORTRAN-TO-LISP|::|B-%OFFSET%|)
      (|COMMON-LISP|::|+|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|B-%DATA%|
        (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|N|))
        |FORTRAN-TO-LISP|::|B-%OFFSET%|)
       (|COMMON-LISP|::|*| |FORTRAN-TO-LISP|::|T$| |FORTRAN-TO-LISP|::|Z|)))
     |FORTRAN-TO-LISP|::|LABEL10|))
   |FORTRAN-TO-LISP|::|LABEL999|
   (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
   |FORTRAN-TO-LISP|::|END_LABEL|
   (|COMMON-LISP|::|RETURN|
    (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
     |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
     |COMMON-LISP|::|NIL|)))))

