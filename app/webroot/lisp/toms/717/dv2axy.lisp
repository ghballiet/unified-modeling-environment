;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)

;;;;  ***  SET W = A*X + Y  --  W, X, Y = P-VECTORS, A = SCALAR  ***

(defun fortran-to-lisp::|DV2AXY|
  (p w a x y)
  (declare
   (TYPE (|F2CL-LIB|::|INTEGER4|) p)
   (TYPE (ARRAY DOUBLE-FLOAT (*)) y x w)
   (TYPE (DOUBLE-FLOAT) a))
    
  ;;(incf *dv2axy*)
  (let ((indx 0))
    (declare
     (TYPE (|F2CL-LIB|::|INTEGER4|) indx))
					;    (setf indx 0)
    (f2cl-lib::while (< indx p)
		     (setf (aref w indx)
			   (+ (* a (aref x indx)) (aref y indx)))
		     (incf indx))))

