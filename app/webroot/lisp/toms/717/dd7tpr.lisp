;;; Compiled by f2cl version 2.0 beta Date: 2006/05/05 20:28:21 
;;; Using Lisp CLISP 2.38 (2006-01-24) (built on guru.build.karan.org)
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;  (:coerce-assigns :as-needed) (:array-type ':array) (:array-slicing t)
;;;  (:declare-common nil) (:float-format single-float))

(in-package :common-lisp-user)

;;;;; ***  RETURN THE INNER PRODUCT OF THE P-VECTORS X AND Y.  ***

(defun fortran-to-lisp::|DD7TPR|
  (p x y)
  (declare
   (TYPE (|F2CL-LIB|::|INTEGER4|) p)
   (TYPE (ARRAY DOUBLE-FLOAT (*)) y x))
  ;;(incf *dd7tpr*)
  (let ((indx 0) (dd7tpr 0d0))
					;      (setf indx 0)
					;      (setf dd7tpr 0d0)
    (declare
     (TYPE (|F2CL-LIB|::|INTEGER4|) indx)
     (TYPE (DOUBLE-FLOAT) dd7tpr))


    (f2cl-lib::while (< indx p)
		     (setf dd7tpr (+ dd7tpr (* (aref x indx) (aref y indx))))
		     (incf indx))
    (values dd7tpr nil nil nil)))
