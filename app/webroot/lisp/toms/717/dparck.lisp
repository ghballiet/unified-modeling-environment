;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :fortran-to-lisp)

(DEFUN DPARCK (ALG D IV LIV LV N V)
 (DECLARE
  (TYPE (INTEGER4) N LV LIV ALG)
  (TYPE (ARRAY DOUBLE-FLOAT (*)) V D)
  (TYPE (ARRAY INTEGER4 (*)) IV))
;;; RAB - add local macro def'n to eliminate conditional on stringp for PU
;;;       PU is of type INTEGER and is always the arg for dest-lun in this defun
 (MACROLET ((FFORMAT (DEST-LUN FORMAT-CILIST &REST ARGS)
	      (LET ((STREAM (GENSYM)))
		`(UNLESS F2CL-LIB::*NO-PE-717-DIAGNOSTIC-OUTPUT*
		   (LET ((,STREAM (F2CL-LIB::LUN->STREAM ,DEST-LUN)))
		     (F2CL-LIB::EXECUTE-FORMAT-MAIN ,STREAM ',FORMAT-CILIST ,@ARGS))))))
;;; RAB - remainder of FFORMAT calls expand the above
					;(incf *dparck*)
   (LET*
       ((ALGSAV 51.) (DINIT 38.)
	(DTYPE 16.) (DTYPE0 54.)
	(EPSLON 19.) (INITS 25.)
	(IVNEED 3.) (LASTIV 44.)
	(LASTV 45.) (LMAT 42.)
	(NEXTIV 46.) (NEXTV 47.)
	(NVDFLT 50.) (OLDN 38.)
	(PARPRT 20.) (PARSAV 49.)
	(PERM 58.) (PRUNIT 21.)
	(VNEED 4.))
     (DECLARE
      (TYPE (INTEGER4 51. 51.) ALGSAV)
      (TYPE (INTEGER4 38. 38.) DINIT)
      (TYPE (INTEGER4 16. 16.) DTYPE)
      (TYPE (INTEGER4 54. 54.) DTYPE0)
      (TYPE (INTEGER4 19. 19.) EPSLON)
      (TYPE (INTEGER4 25. 25.) INITS)
      (TYPE (INTEGER4 3. 3.) IVNEED)
      (TYPE (INTEGER4 44. 44.) LASTIV)
      (TYPE (INTEGER4 45. 45.) LASTV)
      (TYPE (INTEGER4 42. 42.) LMAT)
      (TYPE (INTEGER4 46. 46.) NEXTIV)
      (TYPE (INTEGER4 47. 47.) NEXTV)
      (TYPE (INTEGER4 50. 50.) NVDFLT)
      (TYPE (INTEGER4 38. 38.) OLDN)
      (TYPE (INTEGER4 20. 20.) PARPRT)
      (TYPE (INTEGER4 49. 49.) PARSAV)
      (TYPE (INTEGER4 58. 58.) PERM)
      (TYPE (INTEGER4 21. 21.) PRUNIT)
      (TYPE (INTEGER4 4. 4.) VNEED))
     (LET
	 ((BIG #1=0.0d0) (MACHEP -1.0d0)
	  (TINY 1.0d0) (ZERO #1#)
	  (VN (F2CL-INIT-STRING (2. 34.) #2=(4.) NIL))
	  (VM (MAKE-ARRAY 34. :|ELEMENT-TYPE| 'DOUBLE-FLOAT))
	  (VX (MAKE-ARRAY 34. :|ELEMENT-TYPE| 'DOUBLE-FLOAT))
	  (VARNM (F2CL-INIT-STRING (2.) #3=(1.) NIL))
	  (SH (F2CL-INIT-STRING (2.) #3# NIL))
	  (CNGD (F2CL-INIT-STRING (3.) #2# NIL))
	  (DFLT (F2CL-INIT-STRING (3.) #2# NIL))
	  (IJMP 33.)
	  (JLIM (MAKE-ARRAY 4. :|ELEMENT-TYPE| 'INTEGER4
			    :|INITIAL-CONTENTS| '(0. 24. 0. 24.)))
	  (NDFLT (MAKE-ARRAY 4. :|ELEMENT-TYPE| 'INTEGER4
			     :|INITIAL-CONTENTS| '(32. 25. 32. 25.)))
	  (MINIV (MAKE-ARRAY 4. :|ELEMENT-TYPE| 'INTEGER4
			     :|INITIAL-CONTENTS| '(82. 59. 103. 103.))))
       (DECLARE
	(TYPE (DOUBLE-FLOAT) ZERO TINY MACHEP BIG)
	(TYPE (ARRAY (SIMPLE-ARRAY CHARACTER (4.)) (68.)) VN)
	(TYPE (ARRAY DOUBLE-FLOAT (34.)) VX VM)
	(TYPE (ARRAY (SIMPLE-ARRAY CHARACTER (1.)) (2.)) SH VARNM)
	(TYPE (ARRAY (SIMPLE-ARRAY CHARACTER (4.)) (3.)) DFLT CNGD)
	(TYPE (INTEGER4) IJMP)
	(TYPE (ARRAY INTEGER4 (4.)) MINIV NDFLT JLIM))
       (FSET (FREF VN (1. 1.) #4=((1. 2.) (1. 34.))) "EPSL")
       (FSET (FREF VN (2. 1.) #4#) "ON..")
       (FSET (FREF VN (1. 2.) #4#) "PHMN")
       (FSET (FREF VN (2. 2.) #4#) "FC..")
       (FSET (FREF VN (1. 3.) #4#) "PHMX")
       (FSET (FREF VN (2. 3.) #4#) "FC..")
       (FSET (FREF VN (1. 4.) #4#) "DECF")
       (FSET (FREF VN (2. 4.) #4#) "AC..")
       (FSET (FREF VN (1. 5.) #4#) "INCF")
       (FSET (FREF VN (2. 5.) #4#) "AC..")
       (FSET (FREF VN (1. 6.) #4#) "RDFC")
       (FSET (FREF VN (2. 6.) #4#) "MN..")
       (FSET (FREF VN (1. 7.) #4#) "RDFC")
       (FSET (FREF VN (2. 7.) #4#) "MX..")
       (FSET (FREF VN (1. 8.) #4#) "TUNE")
       (FSET (FREF VN (2. 8.) #4#) "R1..")
       (FSET (FREF VN (1. 9.) #4#) "TUNE")
       (FSET (FREF VN (2. 9.) #4#) "R2..")
       (FSET (FREF VN (1. 10.) #4#) "TUNE")
       (FSET (FREF VN (2. 10.) #4#) "R3..")
       (FSET (FREF VN (1. 11.) #4#) "TUNE")
       (FSET (FREF VN (2. 11.) #4#) "R4..")
       (FSET (FREF VN (1. 12.) #4#) "TUNE")
       (FSET (FREF VN (2. 12.) #4#) "R5..")
       (FSET (FREF VN (1. 13.) #4#) "AFCT")
       (FSET (FREF VN (2. 13.) #4#) "OL..")
       (FSET (FREF VN (1. 14.) #4#) "RFCT")
       (FSET (FREF VN (2. 14.) #4#) "OL..")
       (FSET (FREF VN (1. 15.) #4#) "XCTO")
       (FSET (FREF VN (2. 15.) #4#) "L...")
       (FSET (FREF VN (1. 16.) #4#) "XFTO")
       (FSET (FREF VN (2. 16.) #4#) "L...")
       (FSET (FREF VN (1. 17.) #4#) "LMAX")
       (FSET (FREF VN (2. 17.) #4#) "0...")
       (FSET (FREF VN (1. 18.) #4#) "LMAX")
       (FSET (FREF VN (2. 18.) #4#) "S...")
       (FSET (FREF VN (1. 19.) #4#) "SCTO")
       (FSET (FREF VN (2. 19.) #4#) "L...")
       (FSET (FREF VN (1. 20.) #4#) "DINI")
       (FSET (FREF VN (2. 20.) #4#) "T...")
       (FSET (FREF VN (1. 21.) #4#) "DTIN")
       (FSET (FREF VN (2. 21.) #4#) "IT..")
       (FSET (FREF VN (1. 22.) #4#) "D0IN")
       (FSET (FREF VN (2. 22.) #4#) "IT..")
       (FSET (FREF VN (1. 23.) #4#) "DFAC")
       (FSET (FREF VN (2. 23.) #4#) "....")
       (FSET (FREF VN (1. 24.) #4#) "DLTF")
       (FSET (FREF VN (2. 24.) #4#) "DC..")
       (FSET (FREF VN (1. 25.) #4#) "DLTF")
       (FSET (FREF VN (2. 25.) #4#) "DJ..")
       (FSET (FREF VN (1. 26.) #4#) "DELT")
       (FSET (FREF VN (2. 26.) #4#) "A0..")
       (FSET (FREF VN (1. 27.) #4#) "FUZZ")
       (FSET (FREF VN (2. 27.) #4#) "....")
       (FSET (FREF VN (1. 28.) #4#) "RLIM")
       (FSET (FREF VN (2. 28.) #4#) "IT..")
       (FSET (FREF VN (1. 29.) #4#) "COSM")
       (FSET (FREF VN (2. 29.) #4#) "IN..")
       (FSET (FREF VN (1. 30.) #4#) "HUBE")
       (FSET (FREF VN (2. 30.) #4#) "RC..")
       (FSET (FREF VN (1. 31.) #4#) "RSPT")
       (FSET (FREF VN (2. 31.) #4#) "OL..")
       (FSET (FREF VN (1. 32.) #4#) "SIGM")
       (FSET (FREF VN (2. 32.) #4#) "IN..")
       (FSET (FREF VN (1. 33.) #4#) "ETA0")
       (FSET (FREF VN (2. 33.) #4#) "....")
       (FSET (FREF VN (1. 34.) #4#) "BIAS")
       (FSET (FREF VN (2. 34.) #4#) "....")
       (FSET (FREF VM (1.) #5=((1. 34.))) 0.001d0)
       (FSET (FREF VM (2.) #5#) -0.99d0)
       (FSET (FREF VM (3.) #5#) 0.001d0)
       (FSET (FREF VM (4.) #5#) 0.01d0)
       (FSET (FREF VM (5.) #5#) 1.2d0)
       (FSET (FREF VM (6.) #5#) 0.01d0)
       (FSET (FREF VM (7.) #5#) 1.2d0)
       (FSET (FREF VM (8.) #5#) #1#)
       (FSET (FREF VM (9.) #5#) #1#)
       (FSET (FREF VM (10.) #5#) 0.001d0)
       (FSET (FREF VM (11.) #5#) -1.0d0)
       (FSET (FREF VM (13.) #5#) #1#)
       (FSET (FREF VM (15.) #5#) #1#)
       (FSET (FREF VM (16.) #5#) #1#)
       (FSET (FREF VM (19.) #5#) #1#)
       (FSET (FREF VM (20.) #5#) -10.0d0)
       (FSET (FREF VM (21.) #5#) #1#)
       (FSET (FREF VM (22.) #5#) #1#)
       (FSET (FREF VM (23.) #5#) #1#)
       (FSET (FREF VM (27.) #5#) 1.01d0)
       (FSET (FREF VM (28.) #5#) 1.0d10)
       (FSET (FREF VM (30.) #5#) #1#)
       (FSET (FREF VM (31.) #5#) #1#)
       (FSET (FREF VM (32.) #5#) #1#)
       (FSET (FREF VM (34.) #5#) #1#)
       (FSET (FREF VX (1.) #6=((1. 34.))) 0.9d0)
       (FSET (FREF VX (2.) #6#) -0.001d0)
       (FSET (FREF VX (3.) #6#) 10.0d0)
       (FSET (FREF VX (4.) #6#) 0.8d0)
       (FSET (FREF VX (5.) #6#) 100.0d0)
       (FSET (FREF VX (6.) #6#) 0.8d0)
       (FSET (FREF VX (7.) #6#) 100.0d0)
       (FSET (FREF VX (8.) #6#) 0.5d0)
       (FSET (FREF VX (9.) #6#) 0.5d0)
       (FSET (FREF VX (10.) #6#) 1.0d0)
       (FSET (FREF VX (11.) #6#) 1.0d0)
       (FSET (FREF VX (14.) #6#) 0.1d0)
       (FSET (FREF VX (15.) #6#) 1.0d0)
       (FSET (FREF VX (16.) #6#) 1.0d0)
       (FSET (FREF VX (19.) #6#) 1.0d0)
       (FSET (FREF VX (23.) #6#) 1.0d0)
       (FSET (FREF VX (24.) #6#) 1.0d0)
       (FSET (FREF VX (25.) #6#) 1.0d0)
       (FSET (FREF VX (26.) #6#) 1.0d0)
       (FSET (FREF VX (27.) #6#) 1.0d10)
       (FSET (FREF VX (29.) #6#) 1.0d0)
       (FSET (FREF VX (31.) #6#) 1.0d0)
       (FSET (FREF VX (32.) #6#) 1.0d0)
       (FSET (FREF VX (33.) #6#) 1.0d0)
       (FSET (FREF VX (34.) #6#) 1.0d0)
       (FSET (FREF VARNM (1.) #7=((1. 2.))) "P")
       (FSET (FREF VARNM (2.) #7#) "P")
       (FSET (FREF SH (1.) #8=((1. 2.))) "S")
       (FSET (FREF SH (2.) #8#) "H")
       (FSET (FREF CNGD (1.) #9=((1. 3.))) "---C")
       (FSET (FREF CNGD (2.) #9#) "HANG")
       (FSET (FREF CNGD (3.) #9#) "ED V")
       (FSET (FREF DFLT (1.) #10=((1. 3.))) "NOND")
       (FSET (FREF DFLT (2.) #10#) "EFAU")
       (FSET (FREF DFLT (3.) #10#) "LT V")
       (WITH-MULTI-ARRAY-DATA
	   ((IV INTEGER4 IV-%DATA% IV-%OFFSET%)
	    (D DOUBLE-FLOAT D-%DATA% D-%OFFSET%)
	    (V DOUBLE-FLOAT V-%DATA% V-%OFFSET%))
	 (PROG
	     ((VK #1#)
	      (WHICH (F2CL-INIT-STRING (3.) (4.) NIL))
	      (ALG1 0.) (I 0.)
	      (II 0.) (IV1 0.)
	      (J 0.) (K 0.)
	      (L 0.) (M 0.)
	      (MIV1 0.) (MIV2 0.)
	      (NDFALT 0.) (PARSV1 0.)
	      (PU 0.))
	    (DECLARE
	     (TYPE (DOUBLE-FLOAT) VK)
	     (TYPE (ARRAY (SIMPLE-ARRAY CHARACTER (4.)) (3.)) WHICH)
	     (TYPE (INTEGER4) PU PARSV1 NDFALT MIV2 MIV1 M L K J IV1 II I ALG1))
	    (SETF PU 0.)
	    (IF
	     (<= PRUNIT LIV)
	     (SETF PU (FREF IV-%DATA% (PRUNIT) ((1. LIV)) IV-%OFFSET%)))
	    (IF (> ALGSAV LIV)
		(GO LABEL20))
	    (IF (= ALG (FREF IV-%DATA% (ALGSAV) ((1. LIV)) IV-%OFFSET%))
		(GO LABEL20))
	    (IF (/= PU 0.)
		(FFORMAT PU
			 (#11="~%" " THE FIRST PARAMETER TO DIVSET SHOULD BE" 1. (("~3D"))
			      " RATHER THAN" 1. (("~3D")) #12="~%")
			 ALG
			 (FREF IV-%DATA%
			       (ALGSAV) ((1. LIV))
			       IV-%OFFSET%)))
	    (SETF (FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%) 67.)
	    (GO LABEL999)
	    LABEL20
	    (IF (OR (< ALG 1.) (> ALG 4.))
		(GO LABEL340))
	    (SETF MIV1 (FREF MINIV (ALG) ((1. 4.))))
	    (IF (= (FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%) 15.)
		(GO LABEL360))
	    (SETF ALG1
		  (INT-ADD (MOD (INT-SUB ALG 1.) 2.) 1.))
	    (IF (= (FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%) 0.)
		(DIVSET ALG IV LIV LV V))
	    (SETF IV1 (FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%))
	    (IF (AND (/= IV1 13.) (/= IV1 12.))
		(GO LABEL30))
	    (IF (<= PERM LIV)
		(SETF MIV1
		      (MAX0 MIV1
			    (INT-SUB
			     (FREF IV-%DATA%
				   (PERM) ((1. LIV))
				   IV-%OFFSET%)
			     1.))))
	    (IF
	     (<= IVNEED
		 LIV)
	     (SETF MIV2
		   (INT-ADD MIV1
			    (MAX0
			     (FREF IV-%DATA%
				   (IVNEED) ((1. LIV))
				   IV-%OFFSET%)
			     0.))))
	    (IF
	     (<= LASTIV
		 LIV)
	     (SETF
	      (FREF IV-%DATA%
		    (LASTIV) ((1. LIV))
		    IV-%OFFSET%)
	      MIV2))
	    (IF
	     (< LIV MIV1)
	     (GO LABEL300))
	    (SETF
	     (FREF IV-%DATA%
		   (IVNEED) ((1. LIV))
		   IV-%OFFSET%)
	     0.)
	    (SETF
	     (FREF IV-%DATA%
		   (LASTV) ((1. LIV))
		   IV-%OFFSET%)
	     (INT-SUB
	      (INT-ADD
	       (MAX0
		(FREF IV-%DATA%
		      (VNEED) ((1. LIV))
		      IV-%OFFSET%)
		0.)
	       (FREF IV-%DATA%
		     (LMAT) ((1. LIV))
		     IV-%OFFSET%))
	      1.))
	    (SETF
	     (FREF IV-%DATA%
		   (VNEED) ((1. LIV))
		   IV-%OFFSET%)
	     0.)
	    (IF
	     (< LIV MIV2)
	     (GO LABEL300))
	    (IF
	     (< LV
		(FREF IV-%DATA%
		      (LASTV) ((1. LIV))
		      IV-%OFFSET%))
	     (GO LABEL320))
	    LABEL30
	    (IF
	     (OR (< IV1 12.)
		 (> IV1 14.))
	     (GO LABEL60))
	    (IF (>= N 1.)
		(GO LABEL50))
	    (SETF
	     (FREF IV-%DATA% (1.)
		   ((1. LIV)) IV-%OFFSET%)
	     81.)
	    (IF (= PU 0.)
		(GO LABEL999))
	    (FFORMAT PU
		     (#11# " /// BAD" 1. (("~1A")) " =" 1. (("~5D")) #12#)
		     (FREF VARNM
			   (ALG1) ((1. 2.)))
		     N)
	    (GO LABEL999)
	    LABEL50
	    (IF (/= IV1 14.)
		(SETF
		 (FREF IV-%DATA%
		       (NEXTIV) ((1. LIV))
		       IV-%OFFSET%)
		 (FREF IV-%DATA%
		       (PERM) ((1. LIV))
		       IV-%OFFSET%)))
	    (IF (/= IV1 14.)
		(SETF
		 (FREF IV-%DATA%
		       (NEXTV) ((1. LIV))
		       IV-%OFFSET%)
		 (FREF IV-%DATA%
		       (LMAT) ((1. LIV))
		       IV-%OFFSET%)))
	    (IF (= IV1 13.)
		(GO LABEL999))
	    (SETF K
		  (INT-SUB
		   (FREF IV-%DATA%
			 (PARSAV) ((1. LIV))
			 IV-%OFFSET%)
		   EPSLON))
	    (DV7DFL ALG1
		    (INT-SUB LV K)
		    (ARRAY-SLICE V
				 DOUBLE-FLOAT
				 ((+ K 1.))
				 ((1. LV))))
	    (SETF
	     (FREF IV-%DATA%
		   (DTYPE0) ((1. LIV))
		   IV-%OFFSET%)
	     (INT-SUB 2. ALG1))
	    (SETF
	     (FREF IV-%DATA%
		   (OLDN) ((1. LIV))
		   IV-%OFFSET%)
	     N)
	    (F2CL-SET-STRING
	     (FREF WHICH (1.) ((1. 3.)))
	     (FREF DFLT (1.) ((1. 3.)))
	     (STRING 4.))
	    (F2CL-SET-STRING
	     (FREF WHICH (2.) ((1. 3.)))
	     (FREF DFLT (2.) ((1. 3.)))
	     (STRING 4.))
	    (F2CL-SET-STRING
	     (FREF WHICH (3.) ((1. 3.)))
	     (FREF DFLT (3.) ((1. 3.)))
	     (STRING 4.))
	    (GO LABEL110)
	    LABEL60
	    (IF
	     (= N
		(FREF IV-%DATA%
		      (OLDN) ((1. LIV))
		      IV-%OFFSET%))
	     (GO LABEL80))
	    (SETF
	     (FREF IV-%DATA% (1.)
		   ((1. LIV)) IV-%OFFSET%)
	     17.)
	    (IF (= PU 0.)
		(GO LABEL999))
	    (FFORMAT PU
		     (#11# " /// " 1. (("~1A")) " CHANGED FROM " 1. (("~5D")) " TO " 1.
			   (("~5D")) #12#)
		     (FREF VARNM
			   (ALG1) ((1. 2.)))
		     (FREF IV-%DATA%
			   (OLDN) ((1. LIV))
			   IV-%OFFSET%)
		     N)
	    (GO LABEL999)
	    LABEL80
	    (IF
	     (AND (<= IV1 11.)
		  (>= IV1 1.))
	     (GO LABEL100))
	    (SETF
	     (FREF IV-%DATA% (1.)
		   ((1. LIV)) IV-%OFFSET%)
	     80.)
	    (IF (/= PU 0.)
		(FFORMAT PU
			 (#11# " ///  IV(1) =" 1. (("~5D")) " SHOULD BE BETWEEN 0 AND 14." #12#)
			 IV1))
	    (GO LABEL999)
	    LABEL100
	    (F2CL-SET-STRING
	     (FREF WHICH (1.) ((1. 3.)))
	     (FREF CNGD (1.) ((1. 3.)))
	     (STRING 4.))
	    (F2CL-SET-STRING
	     (FREF WHICH (2.) ((1. 3.)))
	     (FREF CNGD (2.) ((1. 3.)))
	     (STRING 4.))
	    (F2CL-SET-STRING
	     (FREF WHICH (3.) ((1. 3.)))
	     (FREF CNGD (3.) ((1. 3.)))
	     (STRING 4.))
	    LABEL110
	    (IF (= IV1 14.)
		(SETF IV1 12.))
	    (IF
	     (> BIG TINY)
	     (GO LABEL120))
	    (SETF TINY (DR7MDC 1.))
	    (SETF MACHEP (DR7MDC 3.))
	    (SETF BIG (DR7MDC 6.))
	    (SETF (FREF VM (12.) ((1. 34.))) MACHEP)
	    (SETF (FREF VX (12.) ((1. 34.))) BIG)
	    (SETF (FREF VX (13.) ((1. 34.))) BIG)
	    (SETF (FREF VM (14.) ((1. 34.))) MACHEP)
	    (SETF (FREF VM (17.) ((1. 34.))) TINY)
	    (SETF (FREF VX (17.) ((1. 34.))) BIG)
	    (SETF (FREF VM (18.) ((1. 34.))) TINY)
	    (SETF (FREF VX (18.) ((1. 34.))) BIG)
	    (SETF (FREF VX (20.) ((1. 34.))) BIG)
	    (SETF (FREF VX (21.) ((1. 34.))) BIG)
	    (SETF (FREF VX (22.) ((1. 34.))) BIG)
	    (SETF (FREF VM (24.) ((1. 34.))) MACHEP)
	    (SETF (FREF VM (25.) ((1. 34.))) MACHEP)
	    (SETF (FREF VM (26.) ((1. 34.))) MACHEP)
	    (SETF (FREF VX (28.) ((1. 34.))) (DR7MDC 5.))
	    (SETF (FREF VM (29.) ((1. 34.))) MACHEP)
	    (SETF (FREF VX (30.) ((1. 34.))) BIG)
	    (SETF (FREF VM (33.) ((1. 34.))) MACHEP)
	    LABEL120
	    (SETF M 0.)
	    (SETF I 1.)
	    (SETF J (FREF JLIM (ALG1) ((1. 4.))))
	    (SETF K EPSLON)
	    (SETF NDFALT (FREF NDFLT (ALG1) ((1. 4.))))
	    (FDO
	     (L 1.
		(INT-ADD L 1.))
	     ((> L NDFALT)
	      NIL)
	     (TAGBODY
		(SETF VK
		      (FREF V-%DATA%
			    (K) ((1. LV))
			    V-%OFFSET%))
		(IF
		 (AND
		  (>= VK
		      (FREF VM (I)
			    ((1. 34.))))
		  (<= VK
		      (FREF VX (I)
			    ((1. 34.)))))
		 (GO LABEL140))
		(SETF M K)
		(IF (/= PU 0.)
		    (FFORMAT PU
			     (#11# " ///  " 2. (("~4A")) ".. V(" 1. (("~2D")) ") =" 1.
				   (("~11,3,2,0,'*,,'EE")) " SHOULD" " BE BETWEEN" 1.
				   (("~11,3,2,0,'*,,'EE")) " AND" 1. (("~11,3,2,0,'*,,'EE")) #12#)
			     (FREF VN
				   (1. I) ((1. 2.) (1. 34.)))
			     (FREF VN
				   (2. I) ((1. 2.) (1. 34.)))
			     K VK
			     (FREF VM (I)
				   ((1. 34.)))
			     (FREF VX (I)
				   ((1. 34.)))))
	      LABEL140
		(SETF K
		      (INT-ADD K 1.))
		(SETF I
		      (INT-ADD I 1.))
		(IF
		 (= I J)
		 (SETF I
		       IJMP))
	      LABEL150))
	    (IF
	     (=
	      (FREF IV-%DATA%
		    (NVDFLT) ((1. LIV))
		    IV-%OFFSET%)
	      NDFALT)
	     (GO LABEL170))
	    (SETF
	     (FREF IV-%DATA% (1.)
		   ((1. LIV)) IV-%OFFSET%)
	     51.)
	    (IF (= PU 0.)
		(GO LABEL999))
	    (FFORMAT PU
		     (#11# " IV(NVDFLT) =" 1. (("~5D")) " RATHER THAN " 1. (("~5D")) #12#)
		     (FREF IV-%DATA%
			   (NVDFLT) ((1. LIV))
			   IV-%OFFSET%)
		     NDFALT)
	    (GO LABEL999)
	    LABEL170
	    (IF
	     (AND
	      (OR
	       (>
		(FREF IV-%DATA%
		      (DTYPE) ((1. LIV))
		      IV-%OFFSET%)
		0.)
	       (>
		(FREF V-%DATA%
		      (DINIT) ((1. LV))
		      V-%OFFSET%)
		ZERO))
	      (= IV1 12.))
	     (GO LABEL200))
	    (FDO
	     (I 1.
		(INT-ADD I 1.))
	     ((> I N)
	      NIL)
	     (TAGBODY
		(IF
		 (>
		  (FREF D-%DATA%
			(I) ((1. N))
			D-%OFFSET%)
		  ZERO)
		 (GO LABEL190))
		(SETF M 18.)
		(IF (/= PU 0.)
		    (FFORMAT PU
			     (#11# " ///  D(" 1. (("~3D")) ") =" 1. (("~11,3,2,0,'*,,'EE"))
				   " SHOULD BE POSITIVE" #12#)
			     I
			     (FREF D-%DATA%
				   (I) ((1. N))
				   D-%OFFSET%)))
	      LABEL190))
	    LABEL200
	    (IF (= M 0.)
		(GO LABEL210))
	    (SETF
	     (FREF IV-%DATA% (1.)
		   ((1. LIV)) IV-%OFFSET%)
	     M)
	    (GO LABEL999)
	    LABEL210
	    (IF
	     (OR (= PU 0.)
		 (=
		  (FREF IV-%DATA%
			(PARPRT) ((1. LIV))
			IV-%OFFSET%)
		  0.))
	     (GO LABEL999))
	    (IF
	     (OR (/= IV1 12.)
		 (=
		  (FREF IV-%DATA%
			(INITS) ((1. LIV))
			IV-%OFFSET%)
		  (INT-SUB ALG1 1.)))
	     (GO LABEL230))
	    (SETF M 1.)
	    (FFORMAT PU
		     (#11# " NONDEFAULT VALUES...." #11# " INIT" 1. (("~1A")) "..... IV(25) ="
			   1. (("~3D")) #12#)
		     (FREF SH (ALG1)
			   ((1. 2.)))
		     (FREF IV-%DATA%
			   (INITS) ((1. LIV))
			   IV-%OFFSET%))
	    LABEL230
	    (IF
	     (=
	      (FREF IV-%DATA%
		    (DTYPE) ((1. LIV))
		    IV-%OFFSET%)
	      (FREF IV-%DATA%
		    (DTYPE0) ((1. LIV))
		    IV-%OFFSET%))
	     (GO LABEL250))
	    (IF (= M 0.)
		(FFORMAT PU
			 (#11# #13=" " 3. ((#14="~4A")) #15="ALUES...." #11# #12#)
			 WHICH))
	    (SETF M 1.)
	    (FFORMAT PU
		     (" DTYPE..... IV(16) =" 1. (("~3D")) #12#)
		     (FREF IV-%DATA%
			   (DTYPE) ((1. LIV))
			   IV-%OFFSET%))
	    LABEL250
	    (SETF I 1.)
	    (SETF J
		  (FREF JLIM (ALG1)
			((1. 4.))))
	    (SETF K EPSLON)
	    (SETF L
		  (FREF IV-%DATA%
			(PARSAV) ((1. LIV))
			IV-%OFFSET%))
	    (SETF NDFALT
		  (FREF NDFLT
			(ALG1) ((1. 4.))))
	    (FDO
	     (II 1.
		 (INT-ADD II 1.))
	     ((> II NDFALT)
	      NIL)
	     (TAGBODY
		(IF
		 (=
		  (FREF V-%DATA%
			(K) ((1. LV))
			V-%OFFSET%)
		  (FREF V-%DATA%
			(L) ((1. LV))
			V-%OFFSET%))
		 (GO LABEL280))
		(IF (= M 0.)
		    (FFORMAT PU
			     (#11# #13# 3. ((#14#)) #15# #11# #12#) WHICH))
		(SETF M 1.)
		(FFORMAT PU
			 ("~1@T" 2. (("~4A")) ".. V(" 1. (("~2D")) ") =" 1.
				 (("~15,7,2,0,'*,,'EE")) #12#)
			 (FREF VN (1. I)
			       ((1. 2.) (1. 34.)))
			 (FREF VN (2. I)
			       ((1. 2.) (1. 34.)))
			 K
			 (FREF V-%DATA%
			       (K) ((1. LV))
			       V-%OFFSET%))
	      LABEL280
		(SETF K
		      (INT-ADD K 1.))
		(SETF L
		      (INT-ADD L 1.))
		(SETF I
		      (INT-ADD I 1.))
		(IF
		 (= I J)
		 (SETF I
		       IJMP))
	      LABEL290))
	    (SETF
	     (FREF IV-%DATA%
		   (DTYPE0) ((1. LIV))
		   IV-%OFFSET%)
	     (FREF IV-%DATA%
		   (DTYPE) ((1. LIV))
		   IV-%OFFSET%))
	    (SETF PARSV1
		  (FREF IV-%DATA%
			(PARSAV) ((1. LIV))
			IV-%OFFSET%))
	    (DV7CPY
	     (FREF IV-%DATA%
		   (NVDFLT) ((1. LIV))
		   IV-%OFFSET%)
	     (ARRAY-SLICE V
			  DOUBLE-FLOAT (PARSV1)
			  ((1. LV)))
	     (ARRAY-SLICE V
			  DOUBLE-FLOAT (EPSLON)
			  ((1. LV))))
	    (GO LABEL999)
	    LABEL300
	    (SETF
	     (FREF IV-%DATA% (1.)
		   ((1. LIV)) IV-%OFFSET%)
	     15.)
	    (IF (= PU 0.)
		(GO LABEL999))
	    (FFORMAT PU
		     (#11# " /// LIV =" 1. (("~5D")) " MUST BE AT LEAST" 1. (("~5D")) #12#)
		     LIV MIV2)
	    (IF
	     (< LIV MIV1)
	     (GO LABEL999))
	    (IF
	     (< LV
		(FREF IV-%DATA%
		      (LASTV) ((1. LIV))
		      IV-%OFFSET%))
	     (GO LABEL320))
	    (GO LABEL999)
	    LABEL320
	    (SETF
	     (FREF IV-%DATA% (1.)
		   ((1. LIV)) IV-%OFFSET%)
	     16.)
	    (IF (/= PU 0.)
		(FFORMAT PU
			 (#11# " /// LV =" 1. (("~5D")) " MUST BE AT LEAST" 1. (("~5D")) #12#)
			 LV
			 (FREF IV-%DATA%
			       (LASTV) ((1. LIV))
			       IV-%OFFSET%)))
	    (GO LABEL999)
	    LABEL340
	    (SETF
	     (FREF IV-%DATA% (1.)
		   ((1. LIV)) IV-%OFFSET%)
	     67.)
	    (IF (/= PU 0.)
		(FFORMAT PU
			 (#11# " /// ALG =" 1. (("~5D")) " MUST BE 1 2, 3, OR 4" #12#)
			 ALG))
	    (GO LABEL999)
	    LABEL360
	    (IF (/= PU 0.)
		(FFORMAT PU
			 (#11# " /// LIV =" 1. (("~5D")) " MUST BE AT LEAST" 1. (("~5D"))
			       " TO COMPUTE TRUE MIN. LIV AND MIN. LV" #12#)
			 LIV MIV1))
	    (IF
	     (<= LASTIV
		 LIV)
	     (SETF
	      (FREF IV-%DATA%
		    (LASTIV) ((1. LIV))
		    IV-%OFFSET%)
	      MIV1))
	    (IF
	     (<= LASTV LIV)
	     (SETF
	      (FREF IV-%DATA%
		    (LASTV) ((1. LIV))
		    IV-%OFFSET%)
	      0.))
	    LABEL999
	    (GO END_LABEL)
	    END_LABEL
	    (RETURN
	      (VALUES NIL NIL
		      NIL NIL NIL
		      NIL NIL))))))))
