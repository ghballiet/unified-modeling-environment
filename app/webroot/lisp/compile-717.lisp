(load "f2cl/f2cl0")
(load "f2cl/macros")

;;;;;;;;;;;;;;;;
;;; load-717
;;;
;;; this function will load the relevant code for running algorithm
;;; 717.  if a file is part of the 717 package but is not needed for
;;; estimation in HIPM, i have commented it out.

;;; ALLEGRO
;;; the free edition has a limited heap size that keeps us from
;;; compiling all the 717 files at once.  with a little patience,
;;; we can compile all but dg7itb.lisp.
  
;  (compile-file "toms/717/da7sst.lisp")
;  (compile-file "toms/717/dd7tpr.lisp")
;  (compile-file "toms/717/dd7up5.lisp")
;;  (compile-file "toms/717/dg7itb.lisp")
;  (compile-file "toms/717/dg7qsb.lisp")
;  (compile-file "toms/717/dg7qts.lisp")
;  (compile-file "toms/717/dglfb.lisp")
;  (compile-file "toms/717/dh2rfa.lisp")
;  (compile-file "toms/717/dh2rfg.lisp")
;  (compile-file "toms/717/ditsum.lisp")
;  (compile-file "toms/717/divset.lisp")
;  (compile-file "toms/717/dl7itv.lisp")
;  (compile-file "toms/717/dl7ivm.lisp")
;  (compile-file "toms/717/dl7sqr.lisp")
;  (compile-file "toms/717/dl7srt.lisp")
;  (compile-file "toms/717/dl7svn.lisp")
;  (compile-file "toms/717/dl7svx.lisp")
;  (compile-file "toms/717/dl7tvm.lisp")
;  (compile-file "toms/717/dl7vml.lisp")
;  (compile-file "toms/717/dmdc.lisp")
;  (compile-file "toms/717/dparck.lisp")
;  (compile-file "toms/717/dq7adr.lisp")
;  (compile-file "toms/717/dq7rsh.lisp")
;  (compile-file "toms/717/drglgb.lisp")
;  (compile-file "toms/717/drldst.lisp")
;  (compile-file "toms/717/ds7bqn.lisp")
;  (compile-file "toms/717/ds7dmp.lisp")
  (compile-file "toms/717/ds7ipr.lisp")
  (compile-file "toms/717/ds7lup.lisp")
  (compile-file "toms/717/ds7lvm.lisp")
  (compile-file "toms/717/dv2axy.lisp")
  (compile-file "toms/717/dv2nrm.lisp")
  (compile-file "toms/717/dv7cpy.lisp")
  (compile-file "toms/717/dv7dfl.lisp")
  (compile-file "toms/717/dv7ipr.lisp")
  (compile-file "toms/717/dv7scl.lisp")
  (compile-file "toms/717/dv7scp.lisp")
  (compile-file "toms/717/dv7shf.lisp")
  (compile-file "toms/717/dv7vmp.lisp")
  (compile-file "toms/717/i7copy.lisp")
  (compile-file "toms/717/i7pnvr.lisp")
  (compile-file "toms/717/i7shft.lisp")
  (compile-file "toms/717/stopx.lisp")
