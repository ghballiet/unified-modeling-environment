;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|LET*|
 ((|FORTRAN-TO-LISP|::|D| 27.) (|FORTRAN-TO-LISP|::|J| 70.)
  (|FORTRAN-TO-LISP|::|NEXTV| 47.) (|FORTRAN-TO-LISP|::|NFCALL| 6.)
  (|FORTRAN-TO-LISP|::|NFGCAL| 7.) (|FORTRAN-TO-LISP|::|R| 61.)
  (|FORTRAN-TO-LISP|::|REGD| 67.) (|FORTRAN-TO-LISP|::|REGD0| 82.)
  (|FORTRAN-TO-LISP|::|TOOBIG| 2.) (|FORTRAN-TO-LISP|::|VNEED| 4.))
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 27. 27.)
   |FORTRAN-TO-LISP|::|D|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 70. 70.)
   |FORTRAN-TO-LISP|::|J|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 47. 47.)
   |FORTRAN-TO-LISP|::|NEXTV|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 6. 6.)
   |FORTRAN-TO-LISP|::|NFCALL|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 7. 7.)
   |FORTRAN-TO-LISP|::|NFGCAL|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 61. 61.)
   |FORTRAN-TO-LISP|::|R|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 67. 67.)
   |FORTRAN-TO-LISP|::|REGD|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 82. 82.)
   |FORTRAN-TO-LISP|::|REGD0|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 2. 2.)
   |FORTRAN-TO-LISP|::|TOOBIG|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 4. 4.)
   |FORTRAN-TO-LISP|::|VNEED|))
 (|COMMON-LISP|::|LET|
  ((|FORTRAN-TO-LISP|::|NEED1|
    (|COMMON-LISP|::|MAKE-ARRAY| 2. :|ELEMENT-TYPE| '|F2CL-LIB|::|INTEGER4|
     :|INITIAL-CONTENTS| '(1. 0.)))
   (|FORTRAN-TO-LISP|::|NEED2|
    (|COMMON-LISP|::|MAKE-ARRAY| 2. :|ELEMENT-TYPE| '|F2CL-LIB|::|INTEGER4|
     :|INITIAL-CONTENTS| '(2. 0.))))
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|ARRAY| |F2CL-LIB|::|INTEGER4| (2.))
    |FORTRAN-TO-LISP|::|NEED2| |FORTRAN-TO-LISP|::|NEED1|))
  (|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DGLG|
   (|FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|PS|
    |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|RHO| |FORTRAN-TO-LISP|::|RHOI|
    |FORTRAN-TO-LISP|::|RHOR| |FORTRAN-TO-LISP|::|IV| |FORTRAN-TO-LISP|::|LIV|
    |FORTRAN-TO-LISP|::|LV| |FORTRAN-TO-LISP|::|V| |FORTRAN-TO-LISP|::|CALCRJ|
    |FORTRAN-TO-LISP|::|UI| |FORTRAN-TO-LISP|::|UR| |FORTRAN-TO-LISP|::|UF|)
   (|COMMON-LISP|::|DECLARE|
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|LV|
     |FORTRAN-TO-LISP|::|LIV| |FORTRAN-TO-LISP|::|PS| |FORTRAN-TO-LISP|::|P|
     |FORTRAN-TO-LISP|::|N|)
    (|COMMON-LISP|::|TYPE|
     (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT|
      (|COMMON-LISP|::|*|))
     |FORTRAN-TO-LISP|::|UR| |FORTRAN-TO-LISP|::|V| |FORTRAN-TO-LISP|::|RHOR|
     |FORTRAN-TO-LISP|::|X|)
    (|COMMON-LISP|::|TYPE|
     (|COMMON-LISP|::|ARRAY| |F2CL-LIB|::|INTEGER4| (|COMMON-LISP|::|*|))
     |FORTRAN-TO-LISP|::|UI| |FORTRAN-TO-LISP|::|IV|
     |FORTRAN-TO-LISP|::|RHOI|))
   (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
    ((|FORTRAN-TO-LISP|::|RHOI| |F2CL-LIB|::|INTEGER4|
      |FORTRAN-TO-LISP|::|RHOI-%DATA%| |FORTRAN-TO-LISP|::|RHOI-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|IV| |F2CL-LIB|::|INTEGER4|
      |FORTRAN-TO-LISP|::|IV-%DATA%| |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|UI| |F2CL-LIB|::|INTEGER4|
      |FORTRAN-TO-LISP|::|UI-%DATA%| |FORTRAN-TO-LISP|::|UI-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|X| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|X-%DATA%| |FORTRAN-TO-LISP|::|X-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|RHOR| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|RHOR-%DATA%| |FORTRAN-TO-LISP|::|RHOR-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|V| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|V-%DATA%| |FORTRAN-TO-LISP|::|V-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|UR| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|UR-%DATA%| |FORTRAN-TO-LISP|::|UR-%OFFSET%|))
    (|COMMON-LISP|::|PROG|
     ((|FORTRAN-TO-LISP|::|D1| 0.) (|FORTRAN-TO-LISP|::|DR1| 0.)
      (|FORTRAN-TO-LISP|::|I| 0.) (|FORTRAN-TO-LISP|::|IV1| 0.)
      (|FORTRAN-TO-LISP|::|NF| 0.) (|FORTRAN-TO-LISP|::|R1| 0.)
      (|FORTRAN-TO-LISP|::|RD1| 0.))
     (|COMMON-LISP|::|DECLARE|
      (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|RD1|
       |FORTRAN-TO-LISP|::|R1| |FORTRAN-TO-LISP|::|NF| |FORTRAN-TO-LISP|::|IV1|
       |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|DR1|
       |FORTRAN-TO-LISP|::|D1|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|=|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%| (1.)
        ((1. |FORTRAN-TO-LISP|::|LIV|)) |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       0.)
      (|FORTRAN-TO-LISP|::|DIVSET| 1. |FORTRAN-TO-LISP|::|IV|
       |FORTRAN-TO-LISP|::|LIV| |FORTRAN-TO-LISP|::|LV|
       |FORTRAN-TO-LISP|::|V|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IV1|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%| (1.)
       ((1. |FORTRAN-TO-LISP|::|LIV|)) |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|IV1| 14.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL10|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND| (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|IV1| 2.)
       (|COMMON-LISP|::|<| |FORTRAN-TO-LISP|::|IV1| 12.))
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL10|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|IV1| 12.)
      (|COMMON-LISP|::|SETF|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%| (1.)
        ((1. |FORTRAN-TO-LISP|::|LIV|)) |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       13.))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|I|
      (|COMMON-LISP|::|THE| |F2CL-LIB|::|INTEGER4|
       (|COMMON-LISP|::|TRUNCATE|
        (|COMMON-LISP|::|*|
         (|COMMON-LISP|::|+|
          (|COMMON-LISP|::|-| |FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|PS|)
          2.)
         (|COMMON-LISP|::|+|
          (|COMMON-LISP|::|-| |FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|PS|)
          1.))
        2.)))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|=|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%| (1.)
        ((1. |FORTRAN-TO-LISP|::|LIV|)) |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       13.)
      (|COMMON-LISP|::|SETF|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|VNEED|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|F2CL-LIB|::|INT-ADD|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
         (|FORTRAN-TO-LISP|::|VNEED|) ((1. |FORTRAN-TO-LISP|::|LIV|))
         |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
        |FORTRAN-TO-LISP|::|P|
        (|F2CL-LIB|::|INT-MUL| |FORTRAN-TO-LISP|::|N|
         (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|P| 1.
          |FORTRAN-TO-LISP|::|I|)))))
     (|COMMON-LISP|::|MULTIPLE-VALUE-BIND|
      (|FORTRAN-TO-LISP|::|VAR-0| |FORTRAN-TO-LISP|::|VAR-1|
       |FORTRAN-TO-LISP|::|VAR-2| |FORTRAN-TO-LISP|::|VAR-3|
       |FORTRAN-TO-LISP|::|VAR-4| |FORTRAN-TO-LISP|::|VAR-5|
       |FORTRAN-TO-LISP|::|VAR-6| |FORTRAN-TO-LISP|::|VAR-7|
       |FORTRAN-TO-LISP|::|VAR-8| |FORTRAN-TO-LISP|::|VAR-9|
       |FORTRAN-TO-LISP|::|VAR-10| |FORTRAN-TO-LISP|::|VAR-11|
       |FORTRAN-TO-LISP|::|VAR-12| |FORTRAN-TO-LISP|::|VAR-13|
       |FORTRAN-TO-LISP|::|VAR-14| |FORTRAN-TO-LISP|::|VAR-15|
       |FORTRAN-TO-LISP|::|VAR-16|)
      (|FORTRAN-TO-LISP|::|DRGLG| |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|V|
       |FORTRAN-TO-LISP|::|IV| |FORTRAN-TO-LISP|::|LIV| |FORTRAN-TO-LISP|::|LV|
       |FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|PS| |FORTRAN-TO-LISP|::|N|
       |FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|PS| |FORTRAN-TO-LISP|::|V|
       |FORTRAN-TO-LISP|::|V| |FORTRAN-TO-LISP|::|RHO|
       |FORTRAN-TO-LISP|::|RHOI| |FORTRAN-TO-LISP|::|RHOR|
       |FORTRAN-TO-LISP|::|V| |FORTRAN-TO-LISP|::|X|)
      (|COMMON-LISP|::|DECLARE|
       (|COMMON-LISP|::|IGNORE| |FORTRAN-TO-LISP|::|VAR-0|
        |FORTRAN-TO-LISP|::|VAR-1| |FORTRAN-TO-LISP|::|VAR-2|
        |FORTRAN-TO-LISP|::|VAR-3| |FORTRAN-TO-LISP|::|VAR-4|
        |FORTRAN-TO-LISP|::|VAR-6| |FORTRAN-TO-LISP|::|VAR-7|
        |FORTRAN-TO-LISP|::|VAR-8| |FORTRAN-TO-LISP|::|VAR-9|
        |FORTRAN-TO-LISP|::|VAR-10| |FORTRAN-TO-LISP|::|VAR-11|
        |FORTRAN-TO-LISP|::|VAR-12| |FORTRAN-TO-LISP|::|VAR-13|
        |FORTRAN-TO-LISP|::|VAR-14| |FORTRAN-TO-LISP|::|VAR-15|
        |FORTRAN-TO-LISP|::|VAR-16|))
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|N|
       |FORTRAN-TO-LISP|::|VAR-5|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|/=|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%| (1.)
        ((1. |FORTRAN-TO-LISP|::|LIV|)) |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       14.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|D|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NEXTV|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|R|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      (|F2CL-LIB|::|INT-ADD|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|D|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       |FORTRAN-TO-LISP|::|P|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|REGD0|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      (|F2CL-LIB|::|INT-ADD|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|R|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|F2CL-LIB|::|INT-MUL|
        (|F2CL-LIB|::|INT-ADD|
         (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|PS|)
         1.)
        |FORTRAN-TO-LISP|::|N|)))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|J|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      (|COMMON-LISP|::|+|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|REGD0|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|COMMON-LISP|::|*|
        (|COMMON-LISP|::|THE| |F2CL-LIB|::|INTEGER4|
         (|COMMON-LISP|::|TRUNCATE|
          (|COMMON-LISP|::|*|
           (|COMMON-LISP|::|+|
            (|COMMON-LISP|::|-| |FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|PS|)
            2.)
           (|COMMON-LISP|::|+|
            (|COMMON-LISP|::|-| |FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|PS|)
            1.))
          2.))
        |FORTRAN-TO-LISP|::|N|)))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NEXTV|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      (|F2CL-LIB|::|INT-ADD|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|J|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|F2CL-LIB|::|INT-MUL| |FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|PS|)))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|IV1| 13.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
     |FORTRAN-TO-LISP|::|LABEL10|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|D1|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|D|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|DR1|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|J|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|R1|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|R|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|RD1|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|REGD0|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     |FORTRAN-TO-LISP|::|LABEL20|
     (|COMMON-LISP|::|MULTIPLE-VALUE-BIND|
      (|FORTRAN-TO-LISP|::|VAR-0| |FORTRAN-TO-LISP|::|VAR-1|
       |FORTRAN-TO-LISP|::|VAR-2| |FORTRAN-TO-LISP|::|VAR-3|
       |FORTRAN-TO-LISP|::|VAR-4| |FORTRAN-TO-LISP|::|VAR-5|
       |FORTRAN-TO-LISP|::|VAR-6| |FORTRAN-TO-LISP|::|VAR-7|
       |FORTRAN-TO-LISP|::|VAR-8| |FORTRAN-TO-LISP|::|VAR-9|
       |FORTRAN-TO-LISP|::|VAR-10| |FORTRAN-TO-LISP|::|VAR-11|
       |FORTRAN-TO-LISP|::|VAR-12| |FORTRAN-TO-LISP|::|VAR-13|
       |FORTRAN-TO-LISP|::|VAR-14| |FORTRAN-TO-LISP|::|VAR-15|
       |FORTRAN-TO-LISP|::|VAR-16|)
      (|FORTRAN-TO-LISP|::|DRGLG|
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|V|
        |COMMON-LISP|::|DOUBLE-FLOAT| (|FORTRAN-TO-LISP|::|D1|)
        ((1. |FORTRAN-TO-LISP|::|LV|)))
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|V|
        |COMMON-LISP|::|DOUBLE-FLOAT| (|FORTRAN-TO-LISP|::|DR1|)
        ((1. |FORTRAN-TO-LISP|::|LV|)))
       |FORTRAN-TO-LISP|::|IV| |FORTRAN-TO-LISP|::|LIV| |FORTRAN-TO-LISP|::|LV|
       |FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|PS| |FORTRAN-TO-LISP|::|N|
       |FORTRAN-TO-LISP|::|P| |FORTRAN-TO-LISP|::|PS|
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|V|
        |COMMON-LISP|::|DOUBLE-FLOAT| (|FORTRAN-TO-LISP|::|R1|)
        ((1. |FORTRAN-TO-LISP|::|LV|)))
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|V|
        |COMMON-LISP|::|DOUBLE-FLOAT| (|FORTRAN-TO-LISP|::|RD1|)
        ((1. |FORTRAN-TO-LISP|::|LV|)))
       |FORTRAN-TO-LISP|::|RHO| |FORTRAN-TO-LISP|::|RHOI|
       |FORTRAN-TO-LISP|::|RHOR| |FORTRAN-TO-LISP|::|V| |FORTRAN-TO-LISP|::|X|)
      (|COMMON-LISP|::|DECLARE|
       (|COMMON-LISP|::|IGNORE| |FORTRAN-TO-LISP|::|VAR-0|
        |FORTRAN-TO-LISP|::|VAR-1| |FORTRAN-TO-LISP|::|VAR-2|
        |FORTRAN-TO-LISP|::|VAR-3| |FORTRAN-TO-LISP|::|VAR-4|
        |FORTRAN-TO-LISP|::|VAR-6| |FORTRAN-TO-LISP|::|VAR-7|
        |FORTRAN-TO-LISP|::|VAR-8| |FORTRAN-TO-LISP|::|VAR-9|
        |FORTRAN-TO-LISP|::|VAR-10| |FORTRAN-TO-LISP|::|VAR-11|
        |FORTRAN-TO-LISP|::|VAR-12| |FORTRAN-TO-LISP|::|VAR-13|
        |FORTRAN-TO-LISP|::|VAR-14| |FORTRAN-TO-LISP|::|VAR-15|
        |FORTRAN-TO-LISP|::|VAR-16|))
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|N|
       |FORTRAN-TO-LISP|::|VAR-5|))
     (|F2CL-LIB|::|ARITHMETIC-IF|
      (|F2CL-LIB|::|INT-SUB|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%| (1.)
        ((1. |FORTRAN-TO-LISP|::|LIV|)) |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       2.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL30|)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL50|)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL60|))
     |FORTRAN-TO-LISP|::|LABEL30|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NFCALL|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|NEED1| (2.) ((1. 2.)))
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NFGCAL|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|MULTIPLE-VALUE-BIND|
      (|FORTRAN-TO-LISP|::|VAR-0| |FORTRAN-TO-LISP|::|VAR-1|
       |FORTRAN-TO-LISP|::|VAR-2| |FORTRAN-TO-LISP|::|VAR-3|
       |FORTRAN-TO-LISP|::|VAR-4| |FORTRAN-TO-LISP|::|VAR-5|
       |FORTRAN-TO-LISP|::|VAR-6| |FORTRAN-TO-LISP|::|VAR-7|
       |FORTRAN-TO-LISP|::|VAR-8| |FORTRAN-TO-LISP|::|VAR-9|)
      (|COMMON-LISP|::|FUNCALL| |FORTRAN-TO-LISP|::|CALCRJ|
       |FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|PS| |FORTRAN-TO-LISP|::|X|
       |FORTRAN-TO-LISP|::|NF| |FORTRAN-TO-LISP|::|NEED1|
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|V|
        |COMMON-LISP|::|DOUBLE-FLOAT| (|FORTRAN-TO-LISP|::|R1|)
        ((1. |FORTRAN-TO-LISP|::|LV|)))
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|V|
        |COMMON-LISP|::|DOUBLE-FLOAT| (|FORTRAN-TO-LISP|::|DR1|)
        ((1. |FORTRAN-TO-LISP|::|LV|)))
       |FORTRAN-TO-LISP|::|UI| |FORTRAN-TO-LISP|::|UR| |FORTRAN-TO-LISP|::|UF|)
      (|COMMON-LISP|::|DECLARE|
       (|COMMON-LISP|::|IGNORE| |FORTRAN-TO-LISP|::|VAR-2|
        |FORTRAN-TO-LISP|::|VAR-4| |FORTRAN-TO-LISP|::|VAR-5|
        |FORTRAN-TO-LISP|::|VAR-6| |FORTRAN-TO-LISP|::|VAR-7|
        |FORTRAN-TO-LISP|::|VAR-8| |FORTRAN-TO-LISP|::|VAR-9|))
      (|COMMON-LISP|::|WHEN| |FORTRAN-TO-LISP|::|VAR-0|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|N|
        |FORTRAN-TO-LISP|::|VAR-0|))
      (|COMMON-LISP|::|WHEN| |FORTRAN-TO-LISP|::|VAR-1|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|PS|
        |FORTRAN-TO-LISP|::|VAR-1|))
      (|COMMON-LISP|::|WHEN| |FORTRAN-TO-LISP|::|VAR-3|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NF|
        |FORTRAN-TO-LISP|::|VAR-3|)))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|NF| 0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL40|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|TOOBIG|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      1.)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL20|)
     |FORTRAN-TO-LISP|::|LABEL40|
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|>|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%| (1.)
        ((1. |FORTRAN-TO-LISP|::|LIV|)) |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL20|))
     |FORTRAN-TO-LISP|::|LABEL50|
     (|COMMON-LISP|::|MULTIPLE-VALUE-BIND|
      (|FORTRAN-TO-LISP|::|VAR-0| |FORTRAN-TO-LISP|::|VAR-1|
       |FORTRAN-TO-LISP|::|VAR-2| |FORTRAN-TO-LISP|::|VAR-3|
       |FORTRAN-TO-LISP|::|VAR-4| |FORTRAN-TO-LISP|::|VAR-5|
       |FORTRAN-TO-LISP|::|VAR-6| |FORTRAN-TO-LISP|::|VAR-7|
       |FORTRAN-TO-LISP|::|VAR-8| |FORTRAN-TO-LISP|::|VAR-9|)
      (|COMMON-LISP|::|FUNCALL| |FORTRAN-TO-LISP|::|CALCRJ|
       |FORTRAN-TO-LISP|::|N| |FORTRAN-TO-LISP|::|PS| |FORTRAN-TO-LISP|::|X|
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|IV|
        |F2CL-LIB|::|INTEGER4| (|FORTRAN-TO-LISP|::|NFGCAL|)
        ((1. |FORTRAN-TO-LISP|::|LIV|)))
       |FORTRAN-TO-LISP|::|NEED2|
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|V|
        |COMMON-LISP|::|DOUBLE-FLOAT| (|FORTRAN-TO-LISP|::|R1|)
        ((1. |FORTRAN-TO-LISP|::|LV|)))
       (|F2CL-LIB|::|ARRAY-SLICE| |FORTRAN-TO-LISP|::|V|
        |COMMON-LISP|::|DOUBLE-FLOAT| (|FORTRAN-TO-LISP|::|DR1|)
        ((1. |FORTRAN-TO-LISP|::|LV|)))
       |FORTRAN-TO-LISP|::|UI| |FORTRAN-TO-LISP|::|UR| |FORTRAN-TO-LISP|::|UF|)
      (|COMMON-LISP|::|DECLARE|
       (|COMMON-LISP|::|IGNORE| |FORTRAN-TO-LISP|::|VAR-2|
        |FORTRAN-TO-LISP|::|VAR-3| |FORTRAN-TO-LISP|::|VAR-4|
        |FORTRAN-TO-LISP|::|VAR-5| |FORTRAN-TO-LISP|::|VAR-6|
        |FORTRAN-TO-LISP|::|VAR-7| |FORTRAN-TO-LISP|::|VAR-8|
        |FORTRAN-TO-LISP|::|VAR-9|))
      (|COMMON-LISP|::|WHEN| |FORTRAN-TO-LISP|::|VAR-0|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|N|
        |FORTRAN-TO-LISP|::|VAR-0|))
      (|COMMON-LISP|::|WHEN| |FORTRAN-TO-LISP|::|VAR-1|
       (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|PS|
        |FORTRAN-TO-LISP|::|VAR-1|)))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|=|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|NFGCAL|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       0.)
      (|COMMON-LISP|::|SETF|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|TOOBIG|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       1.))
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL20|)
     |FORTRAN-TO-LISP|::|LABEL60|
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|>|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|REGD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       0.)
      (|COMMON-LISP|::|SETF|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|REGD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       |FORTRAN-TO-LISP|::|RD1|))
     |FORTRAN-TO-LISP|::|LABEL999|
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
     |FORTRAN-TO-LISP|::|END_LABEL|
     (|COMMON-LISP|::|RETURN|
      (|COMMON-LISP|::|VALUES| |FORTRAN-TO-LISP|::|N| |COMMON-LISP|::|NIL|
       |FORTRAN-TO-LISP|::|PS| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
       |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
       |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
       |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
       |COMMON-LISP|::|NIL|)))))))

