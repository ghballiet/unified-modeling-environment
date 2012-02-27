(in-package :clim-internals)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; patch for recording.lisp - need to redefine define-invoke-with, and then recompile two calls to it.
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro define-invoke-with (macro-name func-name record-type doc-string)
  `(defmacro ,macro-name ((stream
			   &optional
			   (record-type '',record-type)
			   (record (gensym))
			   &rest initargs)
			  &body body)
     ,doc-string
     (setq stream (stream-designator-symbol stream '*standard-output*))
     (with-gensyms (constructor continuation)
       (multiple-value-bind (bindings m-i-args)
	   (rebind-arguments initargs)
	 `(let ,bindings
	    (flet ((,constructor ()
		     (make-instance ,record-type ,@m-i-args))
		   (,continuation (,stream ,record)
		     ,(declare-ignorable-form* stream record)
		     ,@body))
#+BUGGY	      (declare (dynamic-extent #'constructor #'continuation))
#-BUGGY	      (declare (dynamic-extent #',constructor #',continuation))
	      (,',func-name ,stream #',continuation ,record-type #',constructor
			    ,@m-i-args)))))))

(define-invoke-with with-new-output-record invoke-with-new-output-record
  standard-sequence-output-record
  "Creates a new output record of type RECORD-TYPE and then captures
the output of BODY into the new output record, and inserts the new
record into the current \"open\" output record assotiated with STREAM.
    If RECORD is supplied, it is the name of a variable that will be
lexically bound to the new output record inside the body. INITARGS are
CLOS initargs that are passed to MAKE-INSTANCE when the new output
record is created.
    It returns the created output record.
    The STREAM argument is a symbol that is bound to an output
recording stream. If it is T, *STANDARD-OUTPUT* is used.")

(define-invoke-with with-output-to-output-record
    invoke-with-output-to-output-record
  standard-sequence-output-record
  "Creates a new output record of type RECORD-TYPE and then captures
the output of BODY into the new output record. The cursor position of
STREAM is initially bound to (0,0)
    If RECORD is supplied, it is the name of a variable that will be
lexically bound to the new output record inside the body. INITARGS are
CLOS initargs that are passed to MAKE-INSTANCE when the new output
record is created.
    It returns the created output record.
    The STREAM argument is a symbol that is bound to an output
recording stream. If it is T, *STANDARD-OUTPUT* is used.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; patch for presentations.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro with-output-as-presentation ((stream object type
					       &rest key-args
					       &key modifier single-box
					       (allow-sensitive-inferiors t)
					       parent
					       (record-type
						''standard-presentation)
					       &allow-other-keys)
				       &body body)
  (declare (ignore parent single-box modifier))
  (setq stream (stream-designator-symbol stream '*standard-output*))
  (multiple-value-bind (decls with-body)
      (get-body-declarations body)
    (with-gensyms (record-arg continuation)
      (with-keywords-removed (key-args (:record-type
					:allow-sensitive-inferiors))
	`(flet ((,continuation ()
		  ,@decls
		  ,@with-body))
#+BUGGY	   (declare (dynamic-extent #'continuation))
#-BUGGY	   (declare (dynamic-extent #',continuation))
	   (if (and (output-recording-stream-p ,stream)
		    *allow-sensitive-inferiors*)
	       (with-new-output-record
		   (,stream ,record-type ,record-arg
			    :object ,object
			    :type (expand-presentation-type-abbreviation
				   ,type)
			    ,@key-args)
		 (let ((*allow-sensitive-inferiors*
			,allow-sensitive-inferiors))
		   (,continuation)))
	       (,continuation)))))))