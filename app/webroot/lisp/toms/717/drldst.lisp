;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)

(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DRLDST|
  (|FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|D| |FORTRAN-TO-LISP|::|X|
   |FORTRAN-TO-LISP|::|X0|)
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|P|)
   (|COMMON-LISP|::|TYPE|
    (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT| (|COMMON-LISP|::|*|))
    |FORTRAN-TO-LISP|::|X0| |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|D|))
  (|COMMON-LISP|::|LET*| ((|FORTRAN-TO-LISP|::|ZERO| #1=0.0d0))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT| #1# #1#) |FORTRAN-TO-LISP|::|ZERO|))
 
;(incf *drldst*)

   (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
    ((|FORTRAN-TO-LISP|::|D| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|D-%DATA%| |FORTRAN-TO-LISP|::|D-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|X| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|X-%DATA%| |FORTRAN-TO-LISP|::|X-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|X0| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|X0-%DATA%| |FORTRAN-TO-LISP|::|X0-%OFFSET%|))
    (|COMMON-LISP|::|PROG|
     ((|FORTRAN-TO-LISP|::|EMAX| #1#) (|FORTRAN-TO-LISP|::|XMAX| #1#)
      (|FORTRAN-TO-LISP|::|I| 0.) (|FORTRAN-TO-LISP|::|DRLDST| #1#)
      (|FORTRAN-TO-LISP|::|T$| #1#))
     (|COMMON-LISP|::|DECLARE|
      (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
       |FORTRAN-TO-LISP|::|T$| |FORTRAN-TO-LISP|::|DRLDST|
       |FORTRAN-TO-LISP|::|XMAX| |FORTRAN-TO-LISP|::|EMAX|)
      (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|I|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|EMAX| |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|XMAX| |FORTRAN-TO-LISP|::|ZERO|)
     (|F2CL-LIB|::|FDO|
      (|FORTRAN-TO-LISP|::|I| 1.
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
      ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
       |COMMON-LISP|::|NIL|)
      (|COMMON-LISP|::|TAGBODY|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
        (|COMMON-LISP|::|ABS|
         (|COMMON-LISP|::|*|
          (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|D-%DATA%|
           (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
           |FORTRAN-TO-LISP|::|D-%OFFSET%|)
          (|COMMON-LISP|::|-|
           (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
            (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
            |FORTRAN-TO-LISP|::|X-%OFFSET%|)
           (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X0-%DATA%|
            (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
            |FORTRAN-TO-LISP|::|X0-%OFFSET%|)))))
       (|COMMON-LISP|::|IF|
        (|COMMON-LISP|::|<| |FORTRAN-TO-LISP|::|EMAX| |FORTRAN-TO-LISP|::|T$|)
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|EMAX|
         |FORTRAN-TO-LISP|::|T$|))
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|T$|
        (|COMMON-LISP|::|*|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|D-%DATA%|
          (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
          |FORTRAN-TO-LISP|::|D-%OFFSET%|)
         (|COMMON-LISP|::|+|
          (|COMMON-LISP|::|ABS|
           (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
            (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
            |FORTRAN-TO-LISP|::|X-%OFFSET%|))
          (|COMMON-LISP|::|ABS|
           (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X0-%DATA%|
            (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
            |FORTRAN-TO-LISP|::|X0-%OFFSET%|)))))
       (|COMMON-LISP|::|IF|
        (|COMMON-LISP|::|<| |FORTRAN-TO-LISP|::|XMAX| |FORTRAN-TO-LISP|::|T$|)
        (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|XMAX|
         |FORTRAN-TO-LISP|::|T$|))
       |FORTRAN-TO-LISP|::|LABEL10|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DRLDST|
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|XMAX| |FORTRAN-TO-LISP|::|ZERO|)
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DRLDST|
       (|COMMON-LISP|::|/| |FORTRAN-TO-LISP|::|EMAX|
        |FORTRAN-TO-LISP|::|XMAX|)))
     |FORTRAN-TO-LISP|::|LABEL999|
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
     |FORTRAN-TO-LISP|::|END_LABEL|
     (|COMMON-LISP|::|RETURN|
      (|COMMON-LISP|::|VALUES| |FORTRAN-TO-LISP|::|DRLDST| |COMMON-LISP|::|NIL|
       |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|))))))
