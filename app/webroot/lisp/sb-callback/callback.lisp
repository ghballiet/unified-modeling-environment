;;; callback.lisp -- callback support for CMUCL/x86

;;; This is a SBCL port of Helmut Heller's code from:
;;; http://article.gmane.org/gmane.lisp.cmucl.devel/2472
;;;
;;; Note that this is a straightforward `query-replace-regexp'-based
;;; port as I do not know the SBCL internals at all.
;;;
;;; Damien Diederen <diederen@swing.be>

;;; This package provides a mechanism for defining callbacks: lisp
;;; functions which can be called from foreign code.  The user
;;; interface consists of the macros DEFCALLBACK and CALLBACK.  (See
;;; the doc-strings for details.)
;;;
;;; Below are two examples.  The first example defines a callback FOO
;;; and calls it with alien-funcall.  The second illustrates the use
;;; of the libc qsort function.
;;;
;;; The implementation generates a piece machine code -- a
;;; "trampoline" -- for each callback function.  A pointer to this
;;; trampoline can then be passed to foreign code.  The trampoline is
;;; allocated with malloc and is not moved by the GC.
;;;
;;; When called, the trampoline passes a pointer to the arguments
;;; (essentially the stack pointer) together with an index to
;;; CALL-CALLACK.  CALL-CALLBACK uses the index to find the
;;; corresponding lisp function and calls this function with the
;;; argument pointer.  The lisp function uses the pointer to copy the
;;; arguments form the stack to local variables.  On return, the lisp
;;; function stores the result into the location given by the argument
;;; pointer, and the trampoline code copies the return value from
;;; there into the right return register.
;;;
;;; The address of CALL-CALLBACK is used in every trampoline and must
;;; not be moved by the gc.  It is therefore necessary to either
;;; include this package into the image (core) or to purify before
;;; creating any trampolines (or to invent some other trick).
;;;
;;; Examples: 

#||
;;; Example 1:

(defcallback foo (int (arg1 int) (arg2 int))
  (format t "~&foo: ~S, ~S~%" arg1 arg2)
  (+ arg1 arg2))

(alien-funcall (sap-alien (callback foo) (function int int int))
	       555 444444)

;;; Example 2:

(def-alien-routine qsort void
  (base (* t))
  (nmemb int)
  (size int)
  (compar (* (function int (* t) (* t)))))

(defcallback my< (int (arg1 (* double))
		      (arg2 (* double)))
  (let ((a1 (deref arg1))
	(a2 (deref arg2)))
    (cond ((= a1 a2)  0)
	  ((< a1 a2) -1)
	  (t         +1))))

(let ((a (make-array 10 :element-type 'double-float
		     :initial-contents '(0.1d0 0.5d0 0.2d0 1.2d0 1.5d0
					 2.5d0 0.0d0 0.1d0 0.2d0 0.3d0))))
  (print a)
  (qsort (sb-sys:vector-sap a)
	 (length a)
	 (alien-size double :bytes)
	 (callback my<))
  (print a))

||#

;;; From http://hocwp.free.fr/ah2cl/test-openGL/opengl/callback-sbcl.lisp

(in-package :callback)

(defstruct (callback 
	     (:constructor make-callback (trampoline lisp-fn return-type)))
  "A callback consists of a piece assembly code -- the trampoline --
and a lisp function.  We store the return-type, so we can detect
incompatible redefinitions."
  (trampoline (required-argument) :type system-area-pointer)
  (lisp-fn (required-argument) :type (function (fixnum) (values)))
  (return-type (required-argument) :type sb-alien::alien-type))

(declaim (type (vector callback) *callbacks*))
(defvar *callbacks* (make-array 10 :element-type 'callback
				:fill-pointer 0 :adjustable t)
  "Vector of all callbacks.")


;; (declaim (inline call-callback))
(defun call-callback (index sp-fixnum)
  (declare (type fixnum index sp-fixnum)
	   (optimize speed))
  (funcall (callback-lisp-fn (aref *callbacks* index))
	   sp-fixnum))


;; (declaim (inline create-callback))
(defun create-callback (lisp-fn return-type)
  (let* ((index (fill-pointer *callbacks*))
	 (tramp (make-callback-trampoline index return-type))
	 (cb (make-callback tramp lisp-fn return-type)))
    (vector-push-extend cb *callbacks*)
    cb))


;; (declaim (inline address-of-call-into-lisp))
(defun address-of-call-into-lisp ()
  (sb-sys:sap-int (alien-sap (extern-alien "call_into_lisp" (function (* t))))))


;; (declaim (inline address-of-call-callback))
(defun address-of-call-callback ()
  (sb-kernel:get-lisp-obj-address #'call-callback))

;;; Some abbreviations for alien-type classes.  The $ suffix is there
;;; to prevent name clashes.

(deftype void$ () '(satisfies alien-void-type-p))
(deftype integer$ () 'sb-alien::alien-integer-type)
(deftype integer-64$ () '(satisfies alien-integer-64-type-p))
(deftype signed-integer$ () '(satisfies alien-signed-integer-type-p))
(deftype pointer$ () 'sb-alien::alien-pointer-type)
(deftype single$ () 'sb-alien::alien-single-float-type)
(deftype double$ () 'sb-alien::alien-double-float-type)
(deftype sap$ () '(satisfies alien-sap-type=))


;; (declaim (inline alien-sap-type=))
(defun alien-sap-type= (type)
  (sb-alien::alien-type-= type 
		       (sb-alien::parse-alien-type 'system-area-pointer nil)))


;; (declaim (inline alien-void-type-p))

(defun alien-void-type-p (type)
  (and (sb-alien::alien-values-type-p type)
       (null (sb-alien::alien-values-type-values type))))


;; (declaim (inline alien-integer-64-type-p))
(defun alien-integer-64-type-p (type)
  (and (sb-alien::alien-integer-type-p type)
       (= (sb-alien::alien-type-bits type) 64)))


;; (declaim (inline alien-signed-integer-type-p))
(defun alien-signed-integer-type-p (type)
  (and (sb-alien::alien-integer-type-p type)
       (sb-alien::alien-integer-type-signed type)))


;; (declaim (inline segment-to-trampoline))
(defun segment-to-trampoline (segment length)
  (let* ((code (alien-funcall 
		(extern-alien "malloc" (function system-area-pointer unsigned))
		length))
	 (fill-pointer code))
    (on-segment-contents-vectorly segment
      (lambda (subseg)
	(sb-kernel:copy-byte-vector-to-system-area subseg fill-pointer)
	(setf fill-pointer (sb-sys:sap+ fill-pointer (length subseg)))))
    code))


;; (declaim (inline make-callback-trampoline))
(defun make-callback-trampoline (index return-type)
  "Cons up a piece of code which calls call-callback with INDEX and a
pointer to the arguments."
  (let* ((segment (make-segment))
	 (eax sb-vm::eax-tn)
	 (edx sb-vm::edx-tn)
	 (ebp sb-vm::ebp-tn)
	 (esp sb-vm::esp-tn)
	 ([ebp-8] (sb-vm::make-ea :dword :base ebp :disp -8))
	 ([ebp-4] (sb-vm::make-ea :dword :base ebp :disp -4)))
    ;; The generated assembly roughly corresponds to this C code:
    ;; 
    ;;	 int32 args[2];
    ;;	 args[0] = <index>; 
    ;;	 args[1] = <untagged pointer to arguments (in the caller frame)>;
    ;;	 call_into_lisp (call-callback, args, 2)
    ;;	 // The Lisp side stores the result into args,
    ;;	 // assuming &args == args[1] - 16 bytes.
    ;;	 return *args;
    ;;	       
    (assemble (segment)
	      (inst push ebp)			    ; save old frame pointer
	      (inst mov  ebp esp)		    ; establish new frame
	      (inst mov  eax esp)		    ; pointer to first arg for
	      (inst add  eax 8)			    ;  this function
	      (inst push eax)			    ; arg1 
	      (inst push (ash index 2))		    ; arg0
	      (inst mov  eax esp)		    ; save argsp
	      (inst push 2)			    ; n-args
	      (inst push eax)			    ; argsp
	      (inst push (address-of-call-callback)); function
	      ;; The stack looks now like this:
	      ;;  in-args 
	      ;;  ret-addr
	      ;;  old-fp
	      ;;  arg1 (= &in-args)
	      ;;  arg0 (= index)
	      ;;  2
	      ;;  argsp (= &arg0)
	      ;;  call-callback
	      (inst mov  eax (address-of-call-into-lisp))
	      (inst call eax)
	      ;; now put the result into the right register
	      (etypecase return-type
		(integer-64$ (inst mov eax [ebp-8])
			     (inst mov edx [ebp-4]))
		((or integer$ pointer$ sap$) (inst mov eax [ebp-8]))
#+SBCL-1.0.50	(single$ (inst fld  [ebp-8]))
#+SBCL-1.0.50	(double$ (inst fldd [ebp-8]))
		(void$ ))
	      (inst mov esp ebp)		   ; discard frame
	      (inst pop ebp)			   ; restore frame pointer
	      (inst ret))
    (let ((length (finalize-segment segment)))
      (prog1 (segment-to-trampoline segment length)
	;; FIXME: What is the SBCL equivalent of CMUCL's
	;; RELEASE-SEGMENT? Is there any, or does it just get GCed? -dd
	#+(or) (release-segment segment)))))


;; (declaim (inline symbol-trampoline))
(defun symbol-trampoline (symbol)
  (callback-trampoline (symbol-value symbol)))

(defmacro callback (name)
  "Return the trampoline pointer for the callback NAME."
  `(symbol-trampoline ',name))


;; (declaim (inline compatible-return-types-p))
(defun compatible-return-types-p (type1 type2)
  (flet ((machine-rep (type)
	   (etypecase type
	     (integer-64$ :dword)
	     ((or integer$ pointer$ sap$) :word)
	     (single$ :single)
	     (double$ :double)
	     (void$ :void))))
    (eq (machine-rep type1) (machine-rep type2))))
	       

;; (declaim (inline define-callback-function))
(defun define-callback-function (name lisp-fn return-type)
  (declare (type symbol name)
	   (type function lisp-fn))
  (flet ((register-new-callback () 
	   (setf (symbol-value name)
		 (create-callback lisp-fn return-type))))
    (if (and (boundp name)
	     (callback-p (symbol-value name)))
	;; try do redefine the existing callback
	(let ((callback (find (symbol-trampoline name) *callbacks*
			      :key #'callback-trampoline :test #'sb-sys:sap=)))
	  (cond (callback
		 (let ((old-type (callback-return-type callback)))
		   (cond ((compatible-return-types-p old-type return-type)
			  ;; (format t "~&; Redefining callback ~A~%" name)
			  (setf (callback-lisp-fn callback) lisp-fn)
			  (setf (callback-return-type callback) return-type)
			  callback)
			 (t
			  (let ((e (format nil "~
Attempt to redefine callback with incompatible return type.
   Old type was: ~A 
    New type is: ~A" old-type return-type))
				(c (format nil "~
Create new trampoline (old trampoline calls old lisp function).")))
			    (cerror c e)
			    (register-new-callback))))))
		(t (register-new-callback))))
	(register-new-callback))))


;; (declaim (inline word-aligned-bits))
(defun word-aligned-bits (type)
  (sb-alien::align-offset (sb-alien::alien-type-bits type) sb-vm:n-word-bits))


;; (declaim (inline argument-size))
(defun argument-size (spec)
  (let ((type (sb-alien::parse-alien-type spec nil)))
    (typecase type
      ((or integer$ single$ double$ pointer$ sap$)
       (ceiling (word-aligned-bits type) sb-vm:n-byte-bits))
      (t (error "Unsupported argument type: ~A" spec)))))


;; (declaim (inline parse-return-type))
(defun parse-return-type (spec)
  (let ((sb-alien::*values-type-okay* t))
    (sb-alien::parse-alien-type spec nil)))


;; (declaim (inline return-exp))
(defun return-exp (spec sap body)
  (flet ((store (spec) `(setf (deref (sap-alien ,sap (* ,spec))) ,body)))
    (let ((type (parse-return-type spec)))
      (typecase type
	(void$ body)
	(signed-integer$ 
	 (store `(signed ,(word-aligned-bits type))))
	(integer$
	 (store `(unsigned ,(word-aligned-bits type))))
	((or single$ double$ pointer$ sap$)
	 (store spec))
	(t (error "Unsupported return type: ~A" spec))))))

(defmacro defcallback (name (return-type &rest arg-specs) &body body)
  "(defcallback NAME (RETURN-TYPE {(ARG-NAME ARG-TYPE)}*) {FORM}*)

Define a function which can be called by foreign code.  The pointer
returned by (callback NAME), when called by foreign code, invokes the
lisp function.  The lisp function expects alien arguments of the
specified ARG-TYPEs and returns an alien of type RETURN-TYPE.

If (callback NAME) is already a callback function pointer, its value
is not changed (though it's arranged that an updated version of the
lisp callback function will be called).  This feature allows for
incremental redefinition of callback functions."
  (let ((sp-fixnum (gensym (string :sp-fixnum)))
	(sp (gensym (string :sp))))
    `(progn
      (defun ,name (,sp-fixnum)
	(declare (type fixnum ,sp-fixnum))
	;; We assume sp-fixnum is word aligned and pass it untagged to
	;; this function.  The shift compensates this.
	(let ((,sp (sb-sys:int-sap (ash ,sp-fixnum 2))))
	  (declare (ignorable ,sp))
	  ;; Copy all arguments to local variables.
	  (with-alien ,(loop for offset = 0 then (+ offset 
						    (argument-size type))
			     for (name type) in arg-specs
			     collect `(,name ,type
				       :local (deref (sap-alien 
						      (sb-sys:sap+ ,sp ,offset)
						      (* ,type)))))
	    ,(return-exp return-type `(sb-sys:sap+ ,sp -16) `(progn ,@body))
	    (values))))
      (define-callback-function 
	  ',name #',name ',(parse-return-type return-type)))))

;;; dumping support


(defun restore-callbacks ()
  ;; Create new trampolines on reload.
  (loop for cb across *callbacks*
	for i from 0
	do (setf (callback-trampoline cb)
		 (make-callback-trampoline i (callback-return-type cb)))))

;; *after-save-initializations* contains
;; new-assem::forget-output-blocks, and the assembler may not work
;; before forget-output-blocks was called.  We add 'restore-callback at
;; the end of *after-save-initializations* to sidestep this problem.
(setf sb-ext:*save-hooks*
      (append sb-ext:*save-hooks* (list 'restore-callbacks)))

;;; callback.lisp ends here
