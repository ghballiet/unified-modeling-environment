;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|LET*|
 ((|FORTRAN-TO-LISP|::|HALF| #1=0.5d0)
  (|FORTRAN-TO-LISP|::|SQ2P| #2=0.9189385332046728d0)
  (|FORTRAN-TO-LISP|::|XLOW| (|COMMON-LISP|::|-| 87.0d0))
  (|FORTRAN-TO-LISP|::|ZERO| #3=0.0d0))
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT| #1# #1#)
   |FORTRAN-TO-LISP|::|HALF|)
  (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT| #2# #2#)
   |FORTRAN-TO-LISP|::|SQ2P|)
  (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
   |FORTRAN-TO-LISP|::|XLOW|)
  (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT| #3# #3#)
   |FORTRAN-TO-LISP|::|ZERO|))
 (|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|PHI|
  (|FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|Y|)
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
    |FORTRAN-TO-LISP|::|Y| |FORTRAN-TO-LISP|::|X|))
  (|COMMON-LISP|::|PROG|
   ((|FORTRAN-TO-LISP|::|ARG| #3#) (|FORTRAN-TO-LISP|::|PHI| #3#))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
     |FORTRAN-TO-LISP|::|PHI| |FORTRAN-TO-LISP|::|ARG|))
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|PHI| |FORTRAN-TO-LISP|::|ZERO|)
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|ARG|
    (|COMMON-LISP|::|-|
     (|COMMON-LISP|::|*| (|COMMON-LISP|::|-| |FORTRAN-TO-LISP|::|HALF|)
      |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|X|)
     |FORTRAN-TO-LISP|::|SQ2P| |FORTRAN-TO-LISP|::|Y|))
   (|COMMON-LISP|::|IF|
    (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|ARG| |FORTRAN-TO-LISP|::|XLOW|)
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|PHI|
     (|COMMON-LISP|::|EXP| |FORTRAN-TO-LISP|::|ARG|)))
   |FORTRAN-TO-LISP|::|END_LABEL|
   (|COMMON-LISP|::|RETURN|
    (|COMMON-LISP|::|VALUES| |FORTRAN-TO-LISP|::|PHI| |COMMON-LISP|::|NIL|
     |COMMON-LISP|::|NIL|)))))

