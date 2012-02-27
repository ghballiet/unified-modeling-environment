;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)


(|COMMON-LISP|::|DEFUN| |FORTRAN-TO-LISP|::|DITSUM|
   (|FORTRAN-TO-LISP|::|D| |FORTRAN-TO-LISP|::|G| |FORTRAN-TO-LISP|::|IV|
    |FORTRAN-TO-LISP|::|LIV| |FORTRAN-TO-LISP|::|LV| |FORTRAN-TO-LISP|::|P|
    |FORTRAN-TO-LISP|::|V| |FORTRAN-TO-LISP|::|X|)
   (|COMMON-LISP|::|DECLARE|
;;; RAB - ignore unused LIV and LV
    (|COMMON-LISP|::|IGNORABLE| |FORTRAN-TO-LISP|::|LIV| |FORTRAN-TO-LISP|::|LV|)
    (|COMMON-LISP|::|TYPE|
     (|COMMON-LISP|::|ARRAY| |COMMON-LISP|::|DOUBLE-FLOAT|
      (|COMMON-LISP|::|*|))
     |FORTRAN-TO-LISP|::|X| |FORTRAN-TO-LISP|::|V| |FORTRAN-TO-LISP|::|G|
     |FORTRAN-TO-LISP|::|D|)
    (|COMMON-LISP|::|TYPE|
     (|COMMON-LISP|::|ARRAY| |F2CL-LIB|::|INTEGER4| (|COMMON-LISP|::|*|))
     |FORTRAN-TO-LISP|::|IV|)
    (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|P|
     |FORTRAN-TO-LISP|::|LV| |FORTRAN-TO-LISP|::|LIV|))
(|COMMON-LISP|::|LET*|
 ((|FORTRAN-TO-LISP|::|ALGSAV| 51.) (|FORTRAN-TO-LISP|::|NEEDHD| 36.)
  (|FORTRAN-TO-LISP|::|NFCALL| 6.) (|FORTRAN-TO-LISP|::|NFCOV| 52.)
  (|FORTRAN-TO-LISP|::|NGCALL| 30.) (|FORTRAN-TO-LISP|::|NGCOV| 53.)
  (|FORTRAN-TO-LISP|::|NITER| 31.) (|FORTRAN-TO-LISP|::|OUTLEV| 19.)
  (|FORTRAN-TO-LISP|::|PRNTIT| 39.) (|FORTRAN-TO-LISP|::|PRUNIT| 21.)
  (|FORTRAN-TO-LISP|::|SOLPRT| 22.) (|FORTRAN-TO-LISP|::|STATPR| 23.)
  (|FORTRAN-TO-LISP|::|SUSED| 64.) (|FORTRAN-TO-LISP|::|X0PRT| 24.)
  (|FORTRAN-TO-LISP|::|DSTNRM| 2.) (|FORTRAN-TO-LISP|::|F| 10.)
  (|FORTRAN-TO-LISP|::|F0| 13.) (|FORTRAN-TO-LISP|::|FDIF| 11.)
  (|FORTRAN-TO-LISP|::|NREDUC| 6.) (|FORTRAN-TO-LISP|::|PREDUC| 7.)
  (|FORTRAN-TO-LISP|::|RELDX| 17.) (|FORTRAN-TO-LISP|::|STPPAR| 5.)
  (|FORTRAN-TO-LISP|::|ZERO| #1=0.0d0))
 (|COMMON-LISP|::|DECLARE|
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 51. 51.)
   |FORTRAN-TO-LISP|::|ALGSAV|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 36. 36.)
   |FORTRAN-TO-LISP|::|NEEDHD|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 6. 6.)
   |FORTRAN-TO-LISP|::|NFCALL|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 52. 52.)
   |FORTRAN-TO-LISP|::|NFCOV|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 30. 30.)
   |FORTRAN-TO-LISP|::|NGCALL|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 53. 53.)
   |FORTRAN-TO-LISP|::|NGCOV|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 31. 31.)
   |FORTRAN-TO-LISP|::|NITER|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 19. 19.)
   |FORTRAN-TO-LISP|::|OUTLEV|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 39. 39.)
   |FORTRAN-TO-LISP|::|PRNTIT|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 21. 21.)
   |FORTRAN-TO-LISP|::|PRUNIT|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 22. 22.)
   |FORTRAN-TO-LISP|::|SOLPRT|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 23. 23.)
   |FORTRAN-TO-LISP|::|STATPR|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 64. 64.)
   |FORTRAN-TO-LISP|::|SUSED|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 24. 24.)
   |FORTRAN-TO-LISP|::|X0PRT|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 2. 2.)
   |FORTRAN-TO-LISP|::|DSTNRM|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 10. 10.)
   |FORTRAN-TO-LISP|::|F|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 13. 13.)
   |FORTRAN-TO-LISP|::|F0|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 11. 11.)
   |FORTRAN-TO-LISP|::|FDIF|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 6. 6.)
   |FORTRAN-TO-LISP|::|NREDUC|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 7. 7.)
   |FORTRAN-TO-LISP|::|PREDUC|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 17. 17.)
   |FORTRAN-TO-LISP|::|RELDX|)
  (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4| 5. 5.)
   |FORTRAN-TO-LISP|::|STPPAR|)
  (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT| #1# #1#)
   |FORTRAN-TO-LISP|::|ZERO|))
 (|COMMON-LISP|::|LET|
  ((|FORTRAN-TO-LISP|::|MODEL1|
    (|F2CL-LIB|::|F2CL-INIT-STRING| (6.) #2=(4.)
     (("    ") ("    ") ("    ") ("    ") ("  G ") ("  S "))))
   (|FORTRAN-TO-LISP|::|MODEL2|
    (|F2CL-LIB|::|F2CL-INIT-STRING| (6.) #2#
     ((" G  ") (" S  ") ("G-S ") ("S-G ") ("-S-G") ("-G-S")))))
  (|COMMON-LISP|::|DECLARE|
   (|COMMON-LISP|::|TYPE|
    (|COMMON-LISP|::|ARRAY|
     (|COMMON-LISP|::|SIMPLE-ARRAY| |COMMON-LISP|::|CHARACTER| (4.)) (6.))
    |FORTRAN-TO-LISP|::|MODEL2| |FORTRAN-TO-LISP|::|MODEL1|))
  
;;; RAB - add local macro def'n to eliminate conditional on stringp for PU
;;;       PU is of type INTEGER and is always the arg for dest-lun in this defun
     (|COMMON-LISP|::|MACROLET| ((|F2CL-LIB|::|FFORMAT| (|F2CL-LIB|::|DEST-LUN|
								 |F2CL-LIB|::|FORMAT-CILIST|
								 &REST |F2CL-LIB|::|ARGS|)
		   (|COMMON-LISP|::|LET| ((|F2CL-LIB|::|STREAM| (|COMMON-LISP|::|GENSYM|)))
		     `(|COMMON-LISP|::|UNLESS| |F2CL-LIB|::|*NO-PE-717-DIAGNOSTIC-OUTPUT*|
				  (|COMMON-LISP|::|LET| ((,|F2CL-LIB|::|STREAM| (|F2CL-LIB|::|LUN->STREAM| ,|F2CL-LIB|::|DEST-LUN|)))
						(|F2CL-LIB|::|EXECUTE-FORMAT-MAIN| ,|F2CL-LIB|::|STREAM| ',|F2CL-LIB|::|FORMAT-CILIST| ,@|F2CL-LIB|::|ARGS|))))))
;;; RAB - remainder of FFORMAT calls expand the above

;(incf *ditsum*)

   (|F2CL-LIB|::|WITH-MULTI-ARRAY-DATA|
    ((|FORTRAN-TO-LISP|::|IV| |F2CL-LIB|::|INTEGER4|
      |FORTRAN-TO-LISP|::|IV-%DATA%| |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|D| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|D-%DATA%| |FORTRAN-TO-LISP|::|D-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|G| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|G-%DATA%| |FORTRAN-TO-LISP|::|G-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|V| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|V-%DATA%| |FORTRAN-TO-LISP|::|V-%OFFSET%|)
     (|FORTRAN-TO-LISP|::|X| |COMMON-LISP|::|DOUBLE-FLOAT|
      |FORTRAN-TO-LISP|::|X-%DATA%| |FORTRAN-TO-LISP|::|X-%OFFSET%|))
    (|COMMON-LISP|::|PROG|
     ((|FORTRAN-TO-LISP|::|NRELDF| #1#) (|FORTRAN-TO-LISP|::|OLDF| #1#)
      (|FORTRAN-TO-LISP|::|PRELDF| #1#) (|FORTRAN-TO-LISP|::|RELDF| #1#)
      (|FORTRAN-TO-LISP|::|ALG| 0.) (|FORTRAN-TO-LISP|::|I| 0.)
      (|FORTRAN-TO-LISP|::|IV1| 0.) (|FORTRAN-TO-LISP|::|M| 0.)
      (|FORTRAN-TO-LISP|::|NF| 0.) (|FORTRAN-TO-LISP|::|NG| 0.)
      (|FORTRAN-TO-LISP|::|OL| 0.) (|FORTRAN-TO-LISP|::|PU| 0.))
     (|COMMON-LISP|::|DECLARE|
      (|COMMON-LISP|::|TYPE| (|COMMON-LISP|::|DOUBLE-FLOAT|)
       |FORTRAN-TO-LISP|::|RELDF| |FORTRAN-TO-LISP|::|PRELDF|
       |FORTRAN-TO-LISP|::|OLDF| |FORTRAN-TO-LISP|::|NRELDF|)
      (|COMMON-LISP|::|TYPE| (|F2CL-LIB|::|INTEGER4|) |FORTRAN-TO-LISP|::|PU|
       |FORTRAN-TO-LISP|::|OL| |FORTRAN-TO-LISP|::|NG| |FORTRAN-TO-LISP|::|NF|
       |FORTRAN-TO-LISP|::|M| |FORTRAN-TO-LISP|::|IV1| |FORTRAN-TO-LISP|::|I|
       |FORTRAN-TO-LISP|::|ALG|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|PU|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|PRUNIT|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|PU| 0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IV1|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%| (1.)
       ((1. |FORTRAN-TO-LISP|::|LIV|)) |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|IV1| 62.)
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|IV1|
       (|F2CL-LIB|::|INT-SUB| |FORTRAN-TO-LISP|::|IV1| 51.)))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|OL|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|OUTLEV|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|ALG|
      (|F2CL-LIB|::|INT-ADD|
       (|COMMON-LISP|::|MOD|
        (|F2CL-LIB|::|INT-SUB|
         (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
          (|FORTRAN-TO-LISP|::|ALGSAV|) ((1. |FORTRAN-TO-LISP|::|LIV|))
          |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
         1.)
        2.)
       1.))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|OR| (|COMMON-LISP|::|<| |FORTRAN-TO-LISP|::|IV1| 2.)
       (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|IV1| 15.))
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL370|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|>=| |FORTRAN-TO-LISP|::|IV1| 12.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL120|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|IV1| 2.)
       (|COMMON-LISP|::|=|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
         (|FORTRAN-TO-LISP|::|NITER|) ((1. |FORTRAN-TO-LISP|::|LIV|))
         |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
        0.))
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL390|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|OL| 0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL120|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND| (|COMMON-LISP|::|>=| |FORTRAN-TO-LISP|::|IV1| 10.)
       (|COMMON-LISP|::|=|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
         (|FORTRAN-TO-LISP|::|PRNTIT|) ((1. |FORTRAN-TO-LISP|::|LIV|))
         |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
        0.))
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL120|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|IV1| 2.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL10|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|PRNTIT|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      (|F2CL-LIB|::|INT-ADD|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|PRNTIT|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       1.))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|<|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|PRNTIT|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|F2CL-LIB|::|IABS| |FORTRAN-TO-LISP|::|OL|))
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
     |FORTRAN-TO-LISP|::|LABEL10|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NF|
      (|F2CL-LIB|::|INT-SUB|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|NFCALL|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|F2CL-LIB|::|IABS|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
         (|FORTRAN-TO-LISP|::|NFCOV|) ((1. |FORTRAN-TO-LISP|::|LIV|))
         |FORTRAN-TO-LISP|::|IV-%OFFSET%|))))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|PRNTIT|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      0.)
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|RELDF|
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|PRELDF|
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|OLDF|
      (|COMMON-LISP|::|MAX|
       (|COMMON-LISP|::|ABS|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
         (|FORTRAN-TO-LISP|::|F0|) ((1. |FORTRAN-TO-LISP|::|LV|))
         |FORTRAN-TO-LISP|::|V-%OFFSET%|))
       (|COMMON-LISP|::|ABS|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
         (|FORTRAN-TO-LISP|::|F|) ((1. |FORTRAN-TO-LISP|::|LV|))
         |FORTRAN-TO-LISP|::|V-%OFFSET%|))))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|<=| |FORTRAN-TO-LISP|::|OLDF| |FORTRAN-TO-LISP|::|ZERO|)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL20|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|RELDF|
      (|COMMON-LISP|::|/|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
        (|FORTRAN-TO-LISP|::|FDIF|) ((1. |FORTRAN-TO-LISP|::|LV|))
        |FORTRAN-TO-LISP|::|V-%OFFSET%|)
       |FORTRAN-TO-LISP|::|OLDF|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|PRELDF|
      (|COMMON-LISP|::|/|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
        (|FORTRAN-TO-LISP|::|PREDUC|) ((1. |FORTRAN-TO-LISP|::|LV|))
        |FORTRAN-TO-LISP|::|V-%OFFSET%|)
       |FORTRAN-TO-LISP|::|OLDF|))
     |FORTRAN-TO-LISP|::|LABEL20|
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|OL| 0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL60|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND|
       (|COMMON-LISP|::|=|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
         (|FORTRAN-TO-LISP|::|NEEDHD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
         |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
        1.)
       (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 1.))
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3="~%" #4="   IT   NF" #5="~6@T" #6="F" #7="~7@T" #8="RELDF" #9="~3@T"
        #10="PRELDF" #11="~3@T" #12="RELDX" #13="~2@T" #14="MODEL  STPPAR"
        #15="~%")
       |COMMON-LISP|::|NIL|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND|
       (|COMMON-LISP|::|=|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
         (|FORTRAN-TO-LISP|::|NEEDHD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
         |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
        1.)
       (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 2.))
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# #16="    IT   NF" #17="~7@T" #18="F" #19="~8@T" #20="RELDF"
        #21="~4@T" #22="PRELDF" #23="~4@T" #24="RELDX" #25="~3@T" #26="STPPAR"
        #15#)
       |COMMON-LISP|::|NIL|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NEEDHD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      0.)
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 2.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL50|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|M|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|SUSED|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (1. ((#27="~6D")) 1. ((#28="~5D")) 1. ((#29="~10,3,2,0,'*,,'EE")) 2.
       ((#30="~9,2,2,0,'*,,'EE")) 1. ((#31="~8,1,2,0,'*,,'EE")) 1.
       ((#32="~3A")) 1. ((#33="~4A")) 2. ((#34="~8,1,2,0,'*,,'EE")) 1.
       ((#35="~9,2,2,0,'*,,'EE")) #15#)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NITER|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      |FORTRAN-TO-LISP|::|NF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|F|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|RELDF| |FORTRAN-TO-LISP|::|PRELDF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|RELDX|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|MODEL1| (|FORTRAN-TO-LISP|::|M|)
       ((1. 6.)))
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|MODEL2| (|FORTRAN-TO-LISP|::|M|)
       ((1. 6.)))
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|STPPAR|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|))
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL120|)
     |FORTRAN-TO-LISP|::|LABEL50|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (1. ((#36="~6D")) 1. ((#37="~5D")) 1. ((#38="~11,3,2,0,'*,,'EE")) 2.
       ((#39="~10,2,2,0,'*,,'EE")) 3. ((#40="~9,1,2,0,'*,,'EE")) 1.
       ((#41="~10,2,2,0,'*,,'EE")) #15#)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NITER|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      |FORTRAN-TO-LISP|::|NF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|F|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|RELDF| |FORTRAN-TO-LISP|::|PRELDF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|RELDX|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|STPPAR|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|))
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL120|)
     |FORTRAN-TO-LISP|::|LABEL60|
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND|
       (|COMMON-LISP|::|=|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
         (|FORTRAN-TO-LISP|::|NEEDHD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
         |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
        1.)
       (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 1.))
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# #42="    IT   NF" #43="~6@T" #44="F" #45="~7@T" #46="RELDF"
        #47="~3@T" #48="PRELDF" #49="~3@T" #50="RELDX" #51="~2@T"
        #52="MODEL  STPPAR" #53="~2@T" #54="D*STEP" #55="~2@T" #56="NPRELDF"
        #15#)
       |COMMON-LISP|::|NIL|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND|
       (|COMMON-LISP|::|=|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
         (|FORTRAN-TO-LISP|::|NEEDHD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
         |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
        1.)
       (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 2.))
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# #57="    IT   NF" #58="~7@T" #59="F" #60="~8@T" #61="RELDF"
        #62="~4@T" #63="PRELDF" #64="~4@T" #65="RELDX" #66="~3@T" #67="STPPAR"
        #68="~3@T" #69="D*STEP" #70="~3@T" #71="NPRELDF" #15#)
       |COMMON-LISP|::|NIL|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NEEDHD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      0.)
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NRELDF|
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|OLDF| |FORTRAN-TO-LISP|::|ZERO|)
      (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NRELDF|
       (|COMMON-LISP|::|/|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
         (|FORTRAN-TO-LISP|::|NREDUC|) ((1. |FORTRAN-TO-LISP|::|LV|))
         |FORTRAN-TO-LISP|::|V-%OFFSET%|)
        |FORTRAN-TO-LISP|::|OLDF|)))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 2.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL90|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|M|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|SUSED|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (1. ((#27#)) 1. ((#28#)) 1. ((#29#)) 2. ((#30#)) 1. ((#31#)) 1. ((#32#))
       1. ((#33#)) 2. ((#34#)) 1. ((#35#)) #15#)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NITER|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      |FORTRAN-TO-LISP|::|NF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|F|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|RELDF| |FORTRAN-TO-LISP|::|PRELDF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|RELDX|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|MODEL1| (|FORTRAN-TO-LISP|::|M|)
       ((1. 6.)))
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|MODEL2| (|FORTRAN-TO-LISP|::|M|)
       ((1. 6.)))
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|STPPAR|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|DSTNRM|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|NRELDF|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL120|)
     |FORTRAN-TO-LISP|::|LABEL90|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (1. ((#36#)) 1. ((#37#)) 1. ((#38#)) 2. ((#39#)) 3. ((#40#)) 1. ((#41#))
       #15#)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NITER|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      |FORTRAN-TO-LISP|::|NF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|F|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|RELDF| |FORTRAN-TO-LISP|::|PRELDF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|RELDX|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|STPPAR|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|DSTNRM|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|NRELDF|)
     |FORTRAN-TO-LISP|::|LABEL120|
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|<=| |FORTRAN-TO-LISP|::|IV1| 2.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|I|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|STATPR|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|I| -1.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL460|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|<|
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|IV1|)
       0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL460|))
     (|F2CL-LIB|::|COMPUTED-GOTO|
      (|FORTRAN-TO-LISP|::|LABEL999| |FORTRAN-TO-LISP|::|LABEL999|
       |FORTRAN-TO-LISP|::|LABEL130| |FORTRAN-TO-LISP|::|LABEL150|
       |FORTRAN-TO-LISP|::|LABEL170| |FORTRAN-TO-LISP|::|LABEL190|
       |FORTRAN-TO-LISP|::|LABEL210| |FORTRAN-TO-LISP|::|LABEL230|
       |FORTRAN-TO-LISP|::|LABEL250| |FORTRAN-TO-LISP|::|LABEL270|
       |FORTRAN-TO-LISP|::|LABEL290| |FORTRAN-TO-LISP|::|LABEL310|
       |FORTRAN-TO-LISP|::|LABEL330| |FORTRAN-TO-LISP|::|LABEL350|
       |FORTRAN-TO-LISP|::|LABEL500|)
      |FORTRAN-TO-LISP|::|IV1|)
     |FORTRAN-TO-LISP|::|LABEL130|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** X-CONVERGENCE *****" #15#) |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL430|)
     |FORTRAN-TO-LISP|::|LABEL150|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** RELATIVE FUNCTION CONVERGENCE *****" #15#)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL430|)
     |FORTRAN-TO-LISP|::|LABEL170|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** X- AND RELATIVE FUNCTION CONVERGENCE *****" #15#)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL430|)
     |FORTRAN-TO-LISP|::|LABEL190|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** ABSOLUTE FUNCTION CONVERGENCE *****" #15#)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL430|)
     |FORTRAN-TO-LISP|::|LABEL210|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** SINGULAR CONVERGENCE *****" #15#) |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL430|)
     |FORTRAN-TO-LISP|::|LABEL230|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** FALSE CONVERGENCE *****" #15#) |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL430|)
     |FORTRAN-TO-LISP|::|LABEL250|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** FUNCTION EVALUATION LIMIT *****" #15#) |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL430|)
     |FORTRAN-TO-LISP|::|LABEL270|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** ITERATION LIMIT *****" #15#) |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL430|)
     |FORTRAN-TO-LISP|::|LABEL290|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** STOPX *****" #15#) |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL430|)
     |FORTRAN-TO-LISP|::|LABEL310|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** INITIAL F(X) CANNOT BE COMPUTED *****" #15#)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL390|)
     |FORTRAN-TO-LISP|::|LABEL330|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** BAD PARAMETERS TO ASSESS *****" #15#) |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
     |FORTRAN-TO-LISP|::|LABEL350|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** GRADIENT COULD NOT BE COMPUTED *****" #15#)
      |COMMON-LISP|::|NIL|)
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|>|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|NITER|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL460|))
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL390|)
     |FORTRAN-TO-LISP|::|LABEL370|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " ***** IV(1) =" 1. (("~5D")) " *****" #15#)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%| (1.)
       ((1. |FORTRAN-TO-LISP|::|LIV|)) |FORTRAN-TO-LISP|::|IV-%OFFSET%|))
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
     |FORTRAN-TO-LISP|::|LABEL390|
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|/=|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|X0PRT|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       0.)
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# "     I     INITIAL X(I)" "~8@T" "D(I)" #3# #3# |COMMON-LISP|::|T|
        ("~1@T" 1. (("~5D")) 1. (("~17,6,2,0,'*,,'EE")) 1.
         (("~14,3,2,0,'*,,'EE")))
        #15#)
       (|COMMON-LISP|::|DO|
        ((|FORTRAN-TO-LISP|::|I| 1.
          (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
         (|FORTRAN-TO-LISP|::|RET| |COMMON-LISP|::|NIL|
          (|COMMON-LISP|::|APPEND| |FORTRAN-TO-LISP|::|RET|
           (|COMMON-LISP|::|LIST| |FORTRAN-TO-LISP|::|I|
            (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
             (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
             |FORTRAN-TO-LISP|::|X-%OFFSET%|)
            (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|D-%DATA%|
             (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
             |FORTRAN-TO-LISP|::|D-%OFFSET%|)))))
        ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
         |FORTRAN-TO-LISP|::|RET|)
        (|COMMON-LISP|::|DECLARE|
         (|COMMON-LISP|::|TYPE| |F2CL-LIB|::|INTEGER4|
          |FORTRAN-TO-LISP|::|I|)))))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|DSTNRM|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|FDIF|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|NREDUC|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|PREDUC|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|RELDX|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|>=| |FORTRAN-TO-LISP|::|IV1| 12.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NEEDHD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      0.)
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|PRNTIT|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      0.)
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|OL| 0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND| (|COMMON-LISP|::|<| |FORTRAN-TO-LISP|::|OL| 0.)
       (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 1.))
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# #4# #5# #6# #7# #8# #9# #10# #11# #12# #13# #14# #15#)
       |COMMON-LISP|::|NIL|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND| (|COMMON-LISP|::|<| |FORTRAN-TO-LISP|::|OL| 0.)
       (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 2.))
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# #16# #17# #18# #19# #20# #21# #22# #23# #24# #25# #26# #15#)
       |COMMON-LISP|::|NIL|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND| (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|OL| 0.)
       (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 1.))
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# #42# #43# #44# #45# #46# #47# #48# #49# #50# #51# #52# #53# #54#
        #55# #56# #15#)
       |COMMON-LISP|::|NIL|))
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|AND| (|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|OL| 0.)
       (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 2.))
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# #57# #58# #59# #60# #61# #62# #63# #64# #65# #66# #67# #68# #69#
        #70# #71# #15#)
       |COMMON-LISP|::|NIL|))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 1.)
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# "     0" 1. (("~5D")) 1. (("~10,3,2,0,'*,,'EE")) #15#)
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|NFCALL|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
        (|FORTRAN-TO-LISP|::|F|) ((1. |FORTRAN-TO-LISP|::|LV|))
        |FORTRAN-TO-LISP|::|V-%OFFSET%|)))
     (|COMMON-LISP|::|IF| (|COMMON-LISP|::|=| |FORTRAN-TO-LISP|::|ALG| 2.)
      (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
       (#3# "     0" 1. (("~5D")) 1. (("~11,3,2,0,'*,,'EE")) #15#)
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|NFCALL|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
        (|FORTRAN-TO-LISP|::|F|) ((1. |FORTRAN-TO-LISP|::|LV|))
        |FORTRAN-TO-LISP|::|V-%OFFSET%|)))
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
     |FORTRAN-TO-LISP|::|LABEL430|
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NEEDHD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      1.)
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|<=|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|STATPR|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL460|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|OLDF|
      (|COMMON-LISP|::|MAX|
       (|COMMON-LISP|::|ABS|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
         (|FORTRAN-TO-LISP|::|F0|) ((1. |FORTRAN-TO-LISP|::|LV|))
         |FORTRAN-TO-LISP|::|V-%OFFSET%|))
       (|COMMON-LISP|::|ABS|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
         (|FORTRAN-TO-LISP|::|F|) ((1. |FORTRAN-TO-LISP|::|LV|))
         |FORTRAN-TO-LISP|::|V-%OFFSET%|))))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|PRELDF|
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NRELDF|
      |FORTRAN-TO-LISP|::|ZERO|)
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|<=| |FORTRAN-TO-LISP|::|OLDF| |FORTRAN-TO-LISP|::|ZERO|)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL440|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|PRELDF|
      (|COMMON-LISP|::|/|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
        (|FORTRAN-TO-LISP|::|PREDUC|) ((1. |FORTRAN-TO-LISP|::|LV|))
        |FORTRAN-TO-LISP|::|V-%OFFSET%|)
       |FORTRAN-TO-LISP|::|OLDF|))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NRELDF|
      (|COMMON-LISP|::|/|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
        (|FORTRAN-TO-LISP|::|NREDUC|) ((1. |FORTRAN-TO-LISP|::|LV|))
        |FORTRAN-TO-LISP|::|V-%OFFSET%|)
       |FORTRAN-TO-LISP|::|OLDF|))
     |FORTRAN-TO-LISP|::|LABEL440|
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NF|
      (|F2CL-LIB|::|INT-SUB|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|NFCALL|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|NFCOV|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)))
     (|COMMON-LISP|::|SETF| |FORTRAN-TO-LISP|::|NG|
      (|F2CL-LIB|::|INT-SUB|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|NGCALL|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|NGCOV|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)))
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " FUNCTION" 1. (("~17,6,2,0,'*,,'EE")) "   RELDX" 1.
       (("~17,3,2,0,'*,,'EE")) #3# " FUNC. EVALS" 1. (("~8D")) "~9@T"
       "GRAD. EVALS" 1. (("~8D")) #3# " PRELDF" 1. (("~16,3,2,0,'*,,'EE"))
       "~6@T" "NPRELDF" 1. (("~15,3,2,0,'*,,'EE")) #15#)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|F|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|V-%DATA%|
       (|FORTRAN-TO-LISP|::|RELDX|) ((1. |FORTRAN-TO-LISP|::|LV|))
       |FORTRAN-TO-LISP|::|V-%OFFSET%|)
      |FORTRAN-TO-LISP|::|NF| |FORTRAN-TO-LISP|::|NG|
      |FORTRAN-TO-LISP|::|PRELDF| |FORTRAN-TO-LISP|::|NRELDF|)
     |FORTRAN-TO-LISP|::|LABEL460|
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|=|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|SOLPRT|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       0.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
     (|COMMON-LISP|::|SETF|
      (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
       (|FORTRAN-TO-LISP|::|NEEDHD|) ((1. |FORTRAN-TO-LISP|::|LIV|))
       |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
      1.)
     (|COMMON-LISP|::|IF|
      (|COMMON-LISP|::|>|
       (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|IV-%DATA%|
        (|FORTRAN-TO-LISP|::|ALGSAV|) ((1. |FORTRAN-TO-LISP|::|LIV|))
        |FORTRAN-TO-LISP|::|IV-%OFFSET%|)
       2.)
      (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|))
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# "     I      FINAL X(I)" "~8@T" "D(I)" "~10@T" "G(I)" #3# #15#)
      |COMMON-LISP|::|NIL|)
     (|F2CL-LIB|::|FDO|
      (|FORTRAN-TO-LISP|::|I| 1.
       (|F2CL-LIB|::|INT-ADD| |FORTRAN-TO-LISP|::|I| 1.))
      ((|COMMON-LISP|::|>| |FORTRAN-TO-LISP|::|I| |FORTRAN-TO-LISP|::|P|)
       |COMMON-LISP|::|NIL|)
      (|COMMON-LISP|::|TAGBODY| |FORTRAN-TO-LISP|::|LABEL480|
       (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
        ("~1@T" 1. (("~5D")) 1. (("~16,6,2,0,'*,,'EE")) 2.
         (("~14,3,2,0,'*,,'EE")) #15#)
        |FORTRAN-TO-LISP|::|I|
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|X-%DATA%|
         (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
         |FORTRAN-TO-LISP|::|X-%OFFSET%|)
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|D-%DATA%|
         (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
         |FORTRAN-TO-LISP|::|D-%OFFSET%|)
        (|F2CL-LIB|::|FREF| |FORTRAN-TO-LISP|::|G-%DATA%|
         (|FORTRAN-TO-LISP|::|I|) ((1. |FORTRAN-TO-LISP|::|P|))
         |FORTRAN-TO-LISP|::|G-%OFFSET%|))))
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|LABEL999|)
     |FORTRAN-TO-LISP|::|LABEL500|
     (|F2CL-LIB|::|FFORMAT| |FORTRAN-TO-LISP|::|PU|
      (#3# " INCONSISTENT DIMENSIONS" #15#) |COMMON-LISP|::|NIL|)
     |FORTRAN-TO-LISP|::|LABEL999|
     (|COMMON-LISP|::|GO| |FORTRAN-TO-LISP|::|END_LABEL|)
     |FORTRAN-TO-LISP|::|END_LABEL|
     (|COMMON-LISP|::|RETURN|
      (|COMMON-LISP|::|VALUES| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
       |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|
       |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL| |COMMON-LISP|::|NIL|))))))))