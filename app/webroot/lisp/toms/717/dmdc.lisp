;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DR7MDC|
  (|FORTRAN-TO-LISP|::|K|)
  (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|K|))
 (|COMMON-LISP|::|PROG| ((|FORTRAN-TO-LISP|::|DR7MDC| 0.0d0))
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
    |FORTRAN-TO-LISP|::|DR7MDC|))
  (|COMMON-LISP|::|COND|
   ((|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|K| 1.)
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DR7MDC|
     (|COMMON-LISP|::|COERCE| (|F2CL-LIB|::|D1MACH| 1.)
      '|COMMON-LISP|::|DOUBLE-FLOAT|)))
   ((|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|K| 2.)
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DR7MDC|
     (|COMMON-LISP|::|COERCE| (|F2CL-LIB|::|FSQRT| (|F2CL-LIB|::|D1MACH| 1.))
      '|COMMON-LISP|::|DOUBLE-FLOAT|)))
   ((|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|K| 3.)
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DR7MDC|
     (|COMMON-LISP|::|COERCE| (|F2CL-LIB|::|D1MACH| 3.)
      '|COMMON-LISP|::|DOUBLE-FLOAT|)))
   ((|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|K| 4.)
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DR7MDC|
     (|COMMON-LISP|::|COERCE| (|F2CL-LIB|::|FSQRT| (|F2CL-LIB|::|D1MACH| 3.))
      '|COMMON-LISP|::|DOUBLE-FLOAT|)))
   ((|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|K| 5.)
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DR7MDC|
     (|COMMON-LISP|::|COERCE| (|F2CL-LIB|::|FSQRT| (|F2CL-LIB|::|D1MACH| 2.))
      '|COMMON-LISP|::|DOUBLE-FLOAT|)))
   ((|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|K| 6.)
    (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DR7MDC|
     (|COMMON-LISP|::|COERCE| (|F2CL-LIB|::|D1MACH| 2.)
      '|COMMON-LISP|::|DOUBLE-FLOAT|))))
  |FORTRAN-TO-LISP|::|END_LABEL|
  (|COMMON-LISP|::|RETURN|
   (|COMMON-LISP|::|VALUES| |FORTRAN-TO-LISP|::|DR7MDC|
    |COMMON-LISP|::|NIL|))))

;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|LET|
 ((|FORTRAN-TO-LISP|::|MDCON|
   (|COMMON-LISP|::|MAKE-ARRAY| 3. :|ELEMENT-TYPE| '|F2CL-LIB|::|INTEGER4|
    :|INITIAL-CONTENTS| '(6. 8. 5.))))
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|ARRAY| |F2CL-LIB|::|INTEGER4| (3.))
   |FORTRAN-TO-LISP|::|MDCON|))
 (|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|I7MDCN| (|FORTRAN-TO-LISP|::|K|)
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|K|))
  (|COMMON-LISP|::|PROG| ((|FORTRAN-TO-LISP|::|I7MDCN| 0.))
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|)
     |FORTRAN-TO-LISP|::|I7MDCN|))
   (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|I7MDCN|
    (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|MDCON| (|FORTRAN-TO-LISP|::|K|)
     ((1. 3.))))
   |FORTRAN-TO-LISP|::|LABEL999|
   (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
   |FORTRAN-TO-LISP|::|END_LABEL|
   (|COMMON-LISP|::|RETURN|
    (|COMMON-LISP|::|VALUES| |FORTRAN-TO-LISP|::|I7MDCN|
     |COMMON-LISP|::|NIL|)))))

