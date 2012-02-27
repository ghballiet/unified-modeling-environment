;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :fortran-to-lisp)

(DEFUN DGLFB
    (N P PS X B RHO RHOI RHOR IV LIV LV V CALCRJ UI UR UF)
  (DECLARE
   (TYPE (F2CL-LIB::INTEGER4) LV LIV PS P N)
   (TYPE (ARRAY DOUBLE-FLOAT (*)) UR V RHOR B X)
   (TYPE (ARRAY F2CL-LIB::INTEGER4 (*)) UI IV RHOI))
  (LET*
      ((COVREQ 15.) (D 27.) (DINIT 38.) (DLTFDJ 43.) (J 70.) (MODE 35.) (NEXTV 47.)
       (NFCALL 6.) (NFGCAL 7.) (NGCALL 30.) (NGCOV 53.) (R 61.) (REGD0 82.) (TOOBIG 2.)
       (VNEED 4.))
    (DECLARE
     (TYPE (F2CL-LIB::INTEGER4 15. 15.) COVREQ)
     (TYPE (F2CL-LIB::INTEGER4 27. 27.) D)
     (TYPE (F2CL-LIB::INTEGER4 38. 38.) DINIT)
     (TYPE (F2CL-LIB::INTEGER4 43. 43.) DLTFDJ)
     (TYPE (F2CL-LIB::INTEGER4 70. 70.) J)
     (TYPE (F2CL-LIB::INTEGER4 35. 35.) MODE)
     (TYPE (F2CL-LIB::INTEGER4 47. 47.) NEXTV)
     (TYPE (F2CL-LIB::INTEGER4 6. 6.) NFCALL)
     (TYPE (F2CL-LIB::INTEGER4 7. 7.) NFGCAL)
     (TYPE (F2CL-LIB::INTEGER4 30. 30.) NGCALL)
     (TYPE (F2CL-LIB::INTEGER4 53. 53.) NGCOV)
     (TYPE (F2CL-LIB::INTEGER4 61. 61.) R)
     (TYPE (F2CL-LIB::INTEGER4 82. 82.) REGD0)
     (TYPE (F2CL-LIB::INTEGER4 2. 2.) TOOBIG)
     (TYPE (F2CL-LIB::INTEGER4 4. 4.) VNEED))
    (LET
	((HLIM 0.1d0) (NEGPT5 -0.5d0) (ONE 1.0d0) (ZERO 0.0d0)
	 (NEED (MAKE-ARRAY 2. :|ELEMENT-TYPE| 'F2CL-LIB::INTEGER4
			   :|INITIAL-CONTENTS| '(1. 0.))))
      (DECLARE
       (TYPE (DOUBLE-FLOAT) ZERO ONE NEGPT5 HLIM)
       (TYPE (ARRAY F2CL-LIB::INTEGER4 (2.)) NEED))
  
					;(incf *dglfb*)

      (F2CL-LIB::WITH-MULTI-ARRAY-DATA
	  ((RHOI F2CL-LIB::INTEGER4 RHOI-%DATA% RHOI-%OFFSET%)
	   (IV F2CL-LIB::INTEGER4 IV-%DATA% IV-%OFFSET%)
	   (UI F2CL-LIB::INTEGER4 UI-%DATA% UI-%OFFSET%)
	   (X DOUBLE-FLOAT X-%DATA% X-%OFFSET%)
	   (B DOUBLE-FLOAT B-%DATA% B-%OFFSET%)
	   (RHOR DOUBLE-FLOAT RHOR-%DATA% RHOR-%OFFSET%)
	   (V DOUBLE-FLOAT V-%DATA% V-%OFFSET%)
	   (UR DOUBLE-FLOAT UR-%DATA% UR-%OFFSET%))
	(PROG
	    ((H 0.0d0) (H0 0.0d0) (T$ 0.0d0) (XK 0.0d0) (XK1 0.0d0) (D1 0.) (DK 0.) (DR1 0.)
	     (I 0.) (I1 0.) (IV1 0.) (J1K 0.) (J1K0 0.) (K 0.) (NF 0.) (NG 0.) (RD1 0.)
	     (R1 0.) (R21 0.) (RS1 0.) (RSN 0.))
	   (DECLARE
	    (TYPE (DOUBLE-FLOAT) XK1 XK T$ H0 H)
	    (TYPE (F2CL-LIB::INTEGER4) RSN RS1 R21 R1 RD1 NG NF K J1K0 
		  J1K IV1 I1 I DR1 DK D1))
	   (IF
	    (= (F2CL-LIB::FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%) 0.)
	    (DIVSET 1. IV LIV LV V))
	   (SETF
	    (F2CL-LIB::FREF IV-%DATA% (COVREQ) ((1. LIV)) IV-%OFFSET%)
	    (F2CL-LIB::INT-SUB (F2CL-LIB::IABS (F2CL-LIB::FREF IV-%DATA% (COVREQ) ((1. LIV))
							       IV-%OFFSET%))))
	   (SETF IV1 (F2CL-LIB::FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%))
	   (IF (= IV1 14.)
	       (GO LABEL10))
	   (IF (AND (> IV1 2.) (< IV1 12.))
	       (GO LABEL10))
	   (IF (= IV1 12.)
	       (SETF (F2CL-LIB::FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%) 13.))
	   (SETF I (THE F2CL-LIB::INTEGER4 (TRUNCATE (* (+ (- P PS) 2.) 
							(+ (- P PS) 1.)) 2.)))
	   (IF (= (F2CL-LIB::FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%) 13.)
	       (SETF (F2CL-LIB::FREF IV-%DATA% (VNEED) ((1. LIV)) IV-%OFFSET%)
		     (F2CL-LIB::INT-ADD (F2CL-LIB::FREF IV-%DATA% (VNEED) 
							((1. LIV))
							IV-%OFFSET%) 
					P
					(F2CL-LIB::INT-MUL N (F2CL-LIB::INT-ADD P 3. I)))))
	   #+DEBUG-TRACER (scipm::tracer "               No Label")
	   (MULTIPLE-VALUE-BIND
		 (VAR-0 VAR-1 VAR-2 VAR-3 VAR-4 VAR-5 VAR-6 VAR-7 VAR-8 VAR-9 VAR-10 VAR-11
			VAR-12 VAR-13 VAR-14 VAR-15 VAR-16 VAR-17)
	       (DRGLGB B X V IV LIV LV N PS N P PS V V RHO RHOI RHOR V X)
	     (DECLARE
	      (IGNORE VAR-0 VAR-1 VAR-2 VAR-3 VAR-4 VAR-5 VAR-7 VAR-8 VAR-9 VAR-10 VAR-11
		      VAR-12 VAR-13 VAR-14 VAR-15 VAR-16 VAR-17))
	     #+DEBUG-TRACER (scipm::tracer (format nil "        DRGLGB call 1;*M-C*:~A" 
					    (scipm::print-vector scipm::*model-constants*)))
	     (SETF N VAR-6))
	   (IF
	    (/= (F2CL-LIB::FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%) 14.)
	    (GO LABEL999))
	   (SETF (F2CL-LIB::FREF IV-%DATA% (D) ((1. LIV)) IV-%OFFSET%)
		 (F2CL-LIB::FREF IV-%DATA% (NEXTV) ((1. LIV)) IV-%OFFSET%))
	   (SETF (F2CL-LIB::FREF IV-%DATA% (R) ((1. LIV)) IV-%OFFSET%)
		 (F2CL-LIB::INT-ADD (F2CL-LIB::FREF IV-%DATA% (D) ((1. LIV)) IV-%OFFSET%) P))
	   (SETF (F2CL-LIB::FREF IV-%DATA% (REGD0) ((1. LIV)) IV-%OFFSET%)
		 (F2CL-LIB::INT-ADD (F2CL-LIB::FREF IV-%DATA% (R) ((1. LIV)) IV-%OFFSET%)
				    (F2CL-LIB::INT-MUL
				     (F2CL-LIB::INT-ADD (F2CL-LIB::INT-SUB P PS) 3.)
				     N)))
	   (SETF (F2CL-LIB::FREF IV-%DATA% (J) ((1. LIV)) IV-%OFFSET%)
		 (+ (F2CL-LIB::FREF IV-%DATA% (REGD0) ((1. LIV)) IV-%OFFSET%)
		    (* (THE F2CL-LIB::INTEGER4
			 (TRUNCATE (* (+ (- P PS) 2.) (+ (- P PS) 1.)) 2.))
		       N)))
	   (SETF (F2CL-LIB::FREF IV-%DATA% (NEXTV) ((1. LIV)) IV-%OFFSET%)
		 (F2CL-LIB::INT-ADD (F2CL-LIB::FREF IV-%DATA% (J) ((1. LIV)) IV-%OFFSET%)
				    (F2CL-LIB::INT-MUL N PS)))
	   (IF (= IV1 13.)
	       (GO LABEL999))
	   LABEL10
	   (SETF D1 (F2CL-LIB::FREF IV-%DATA% (D) ((1. LIV)) IV-%OFFSET%))
	   (SETF DR1 (F2CL-LIB::FREF IV-%DATA% (J) ((1. LIV)) IV-%OFFSET%))
	   (SETF R1 (F2CL-LIB::FREF IV-%DATA% (R) ((1. LIV)) IV-%OFFSET%))
	   (SETF RD1 (F2CL-LIB::FREF IV-%DATA% (REGD0) ((1. LIV)) IV-%OFFSET%))
	   (SETF R21 (F2CL-LIB::INT-SUB RD1 N))
	   (SETF RS1 (F2CL-LIB::INT-SUB R21 N))
	   (SETF RSN (F2CL-LIB::INT-SUB (F2CL-LIB::INT-ADD RS1 N) 1.))
	   LABEL20
	   #+DEBUG-TRACER (scipm::tracer "            LABEL20")
	   #+DEBUG-TRACER-ALL
	   (scipm::tracer-all 				     
	    (format NIL "        pre DRGLGB call 2;*M-C*:~A;IV(1):~A;NF:~A" 
		    (scipm::print-vector scipm::*model-constants*)
		    (format nil "~A" (aref iv 0))
		    (format nil "~A" nf)))
	   (MULTIPLE-VALUE-BIND
		 (VAR-0 VAR-1 VAR-2 VAR-3 VAR-4 VAR-5 VAR-6 VAR-7 VAR-8 VAR-9 VAR-10 VAR-11 
			VAR-12 VAR-13 VAR-14 VAR-15 VAR-16 VAR-17)
	     (DRGLGB B (F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (D1) ((1. LV)))
		     (F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (DR1) ((1. LV)))
		     IV LIV LV N PS N P PS 
		     (F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (R1) ((1. LV)))
		     (F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (RD1) ((1. LV)))
		     RHO RHOI RHOR V X)
	     (DECLARE
	      (IGNORE VAR-0 VAR-1 VAR-2 VAR-3 VAR-4 VAR-5 VAR-7 VAR-8 VAR-9 VAR-10 VAR-11
		      VAR-12 VAR-13 VAR-14 VAR-15 VAR-16 VAR-17))
	     #+DEBUG-TRACER-ALL
	     (scipm::tracer-all 
	      (format NIL "        post DRGLGB call 2;*M-C*:~A;IV(1):~A;NF:~A" 
		      (scipm::print-vector scipm::*model-constants*)
		      (format nil "~A" (aref iv 0))
		      (format nil "~A~%" nf)))
	     (SETF N VAR-6))
	   (F2CL-LIB::ARITHMETIC-IF (F2CL-LIB::INT-SUB
				     (F2CL-LIB::FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%)
				     2.)
				    (GO LABEL30)
				    (GO LABEL50)
				    (progn 
				      (GO LABEL999)))
	   LABEL30
	   #+DEBUG-TRACER (scipm::tracer "          LABEL30")
	   (SETF NF (F2CL-LIB::FREF IV-%DATA% (NFCALL) ((1. LIV)) IV-%OFFSET%))
	   (MULTIPLE-VALUE-BIND
		 (VAR-0 VAR-1 VAR-2 VAR-3 VAR-4 VAR-5 VAR-6 VAR-7 VAR-8 VAR-9)
	       (FUNCALL CALCRJ N PS X NF NEED 
			(F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (R1) ((1. LV)))
			(F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (DR1) ((1. LV))) UI UR UF)
	     (DECLARE
	      (IGNORE VAR-2 VAR-4 VAR-5 VAR-6 VAR-7 VAR-8 VAR-9))
	     (WHEN VAR-0 (SETF N VAR-0))
	     (WHEN VAR-1 (SETF PS VAR-1))
	     (WHEN VAR-3 (SETF NF VAR-3)))
	   (IF (> NF 0.)
	       (GO LABEL40))
	   (SETF (F2CL-LIB::FREF IV-%DATA% (TOOBIG) ((1. LIV)) IV-%OFFSET%) 1.)
	   (GO LABEL20)
	   LABEL40
	   #+DEBUG-TRACER (scipm::tracer "          LABEL40")
	   (DV7CPY N (F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (RS1) ((1. LV)))
		   (F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (R1) ((1. LV))))
	   (IF (> (F2CL-LIB::FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%) 0.)
	       (GO LABEL20))
	   #+DEBUG-TRACER (scipm::tracer "          LABEL50")
	   LABEL50
	   (IF (AND (< (F2CL-LIB::FREF IV-%DATA% (MODE) ((1. LIV)) IV-%OFFSET%) 0.)
		    (= (F2CL-LIB::FREF V-%DATA% (DINIT) ((1. LV)) V-%OFFSET%) ZERO))
	       (DV7SCP P (F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (D1) ((1. LV))) ONE))
	   (SETF DK D1)
	   (SETF NG (F2CL-LIB::INT-SUB
		     (F2CL-LIB::FREF IV-%DATA% (NGCALL) ((1. LIV)) IV-%OFFSET%)
		     1.))
	   (IF (= (F2CL-LIB::FREF IV-%DATA% (1.) ((1. LIV)) IV-%OFFSET%) -1.)
	       (SETF (F2CL-LIB::FREF IV-%DATA% (NGCOV) ((1. LIV)) IV-%OFFSET%)
		     (F2CL-LIB::INT-SUB
		      (F2CL-LIB::FREF IV-%DATA% (NGCOV) ((1. LIV)) IV-%OFFSET%)
		      1.)))
	   (SETF J1K0 DR1)
	   (SETF NF (F2CL-LIB::FREF IV-%DATA% (NFCALL) ((1. LIV)) IV-%OFFSET%))
	   (IF (= NF (F2CL-LIB::FREF IV-%DATA% (NFGCAL) ((1. LIV)) IV-%OFFSET%))
	       (GO LABEL70))
	   (SETF NG (F2CL-LIB::INT-ADD NG 1.))
	   #+DEBUG-TRACER (scipm::tracer "           LABEL50A")
	   (MULTIPLE-VALUE-BIND
		 (VAR-0 VAR-1 VAR-2 VAR-3 VAR-4 VAR-5 VAR-6 VAR-7 VAR-8 VAR-9)
	       (FUNCALL CALCRJ N PS X NF NEED
			(F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (RS1) ((1. LV)))
			(F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (DR1) ((1. LV))) UI UR UF)
	     (DECLARE
	      (IGNORE VAR-2 VAR-4 VAR-5 VAR-6 VAR-7 VAR-8 VAR-9))
	     (WHEN VAR-0 (SETF N VAR-0))
	     (WHEN VAR-1 (SETF PS VAR-1))
	     (WHEN VAR-3 (SETF NF VAR-3)))
	   (IF (> NF 0.)
	       (GO LABEL70))
	   LABEL60
	   (SETF (F2CL-LIB::FREF IV-%DATA% (TOOBIG) ((1. LIV)) IV-%OFFSET%) 1.)
	   (SETF (F2CL-LIB::FREF IV-%DATA% (NGCALL) ((1. LIV)) IV-%OFFSET%) NG)
	   (GO LABEL20)
	   #+DEBUG-TRACER (scipm::tracer "         LABEL70")
	   LABEL70
	   (F2CL-LIB::FDO
	    (K 1. (F2CL-LIB::INT-ADD K 1.))
	    ((> K PS) NIL)
	    (TAGBODY
	       (SETF J1K J1K0)
	       (SETF J1K0 (F2CL-LIB::INT-ADD J1K0 1.))
	       (IF (>= (F2CL-LIB::FREF B-%DATA% (1. K) ((1. 2.) (1. P)) B-%OFFSET%)
		       (F2CL-LIB::FREF B-%DATA% (2. K) ((1. 2.) (1. P)) B-%OFFSET%))
		   (GO LABEL120))
	       (SETF XK (F2CL-LIB::FREF X-%DATA% (K) ((1. P)) X-%OFFSET%))
	       (SETF H (* (F2CL-LIB::FREF V-%DATA% (DLTFDJ) ((1. LV)) V-%OFFSET%)
			  (MAX (ABS XK) 
			       (/ ONE (F2CL-LIB::FREF V-%DATA% (DK) ((1. LV)) V-%OFFSET%)))))
	       (SETF H0 H)
	       (SETF DK (F2CL-LIB::INT-ADD DK 1.))
	       (SETF T$ NEGPT5)
	       (SETF XK1 (+ XK H))
	       (IF (>= (- XK H) (F2CL-LIB::FREF B-%DATA% (1. K) ((1. 2.) (1. P)) B-%OFFSET%))
		   (GO LABEL80))
	       (SETF T$ (- T$))
	       (IF (> XK1 (F2CL-LIB::FREF B-%DATA% (2. K) ((1. 2.) (1. P)) B-%OFFSET%))
		   (GO LABEL60))
	       #+DEBUG-TRACER (scipm::tracer "         LABEL80")
	     LABEL80
	       (IF (<= XK1 (F2CL-LIB::FREF B-%DATA% (2. K) ((1. 2.) (1. P)) B-%OFFSET%))
		   (GO LABEL90))
	       (SETF T$ (- T$))
	       (SETF H (- H))
	       (SETF XK1 (+ XK H))
	       (IF (< XK1 (F2CL-LIB::FREF B-%DATA% (1. K) ((1. 2.) (1. P)) B-%OFFSET%))
		   (GO LABEL60))
	       #+DEBUG-TRACER (scipm::tracer "         LABEL90")
	     LABEL90
	       (SETF (F2CL-LIB::FREF X-%DATA% (K) ((1. P)) X-%OFFSET%) XK1)
	       (SETF NF (F2CL-LIB::FREF IV-%DATA% (NFGCAL) ((1. LIV)) IV-%OFFSET%))
	       (MULTIPLE-VALUE-BIND
		     (VAR-0 VAR-1 VAR-2 VAR-3 VAR-4 VAR-5 VAR-6 VAR-7 VAR-8 VAR-9)
		   (FUNCALL CALCRJ N PS X NF NEED (F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (R21) ((1. LV)))
			    (F2CL-LIB::ARRAY-SLICE V DOUBLE-FLOAT (DR1) ((1. LV))) UI UR UF)
		 (DECLARE
		  (IGNORE VAR-2 VAR-4 VAR-5 VAR-6 VAR-7 VAR-8 VAR-9))
		 (WHEN VAR-0 (SETF N VAR-0))
		 (WHEN VAR-1 (SETF PS VAR-1))
		 (WHEN VAR-3 (SETF NF VAR-3)))
	       (SETF NG (F2CL-LIB::INT-ADD NG 1.))
	       (IF (> NF 0.)
		   (GO LABEL100))
	       (SETF H (* T$ H))
	       (SETF XK1 (+ XK H))
	       (IF (>= (ABS (/ H H0)) HLIM)
		   (GO LABEL90))
	       (GO LABEL60)
	     LABEL100
	       #+DEBUG-TRACER (scipm::tracer "              LABEL100")
	       (SETF (F2CL-LIB::FREF X-%DATA% (K) ((1. P)) X-%OFFSET%) XK)
	       (SETF (F2CL-LIB::FREF IV-%DATA% (NGCALL) ((1. LIV)) IV-%OFFSET%) NG)
	       (SETF I1 R21)
	       (F2CL-LIB::FDO 
		(I RS1 (F2CL-LIB::INT-ADD I 1.))
		((> I RSN) NIL)
		(TAGBODY
		   (SETF (F2CL-LIB::FREF V-%DATA% (J1K) ((1. LV)) V-%OFFSET%)
			 (/ (- (F2CL-LIB::FREF V-%DATA% (I1) ((1. LV)) V-%OFFSET%)
			       (F2CL-LIB::FREF V-%DATA% (I) ((1. LV)) V-%OFFSET%))
			    H))
		   (SETF I1 (F2CL-LIB::INT-ADD I1 1.))
		   (SETF J1K (F2CL-LIB::INT-ADD J1K PS))
		 LABEL110))
	       (GO LABEL130)
	     LABEL120
	       (F2CL-LIB::FDO 
		(I 1. (F2CL-LIB::INT-ADD I 1.))
		((> I N) NIL)
		(TAGBODY
		   (SETF (F2CL-LIB::FREF V-%DATA% (J1K) ((1. LV)) V-%OFFSET%) ZERO)
		   (SETF J1K (F2CL-LIB::INT-ADD J1K PS))
		 LABEL125))
	     LABEL130))
	   (GO LABEL20)
	   LABEL999
	   (GO END_LABEL)
	   END_LABEL
	   #+DEBUG-TRACER (scipm::tracer (format nil "      >>> END LABEL <<<~%     *M-C*:~A" 
				  scipm::*model-constants*))
	   (RETURN (VALUES N NIL PS NIL NIL NIL NIL NIL NIL
			   NIL NIL NIL NIL NIL NIL NIL)))))))

