(in-package :scipm)

;;; DEFINE-THREADED-PIPE
;; pipe-description ::= ( ( [:start | <input-queue-variable>]
;;                          <function>
;;                          <output-queue-variable>
;;                          <thread-count> )+ )
;; Where: 
;;   :start - There is no input for this part of the pipeline (e.g. "input" may
;;            already be bound in <function>.
;;   <input-queue-variable> - A special variable which is a list of lists of 
;;            values used as input to <function>. The number of items in each
;;            of the component lists must match the number of args the function
;;            takes.
;;   <function> - A function of, which takes its input the next list of values
;;            on the <input-queue-variable> list. It outputs a single list of values
;;            (the number of values must match the number of args expected by the
;;            next function in the queue), which it appends to the
;;            <output-queue-variable> list.
;;   <output-queue-variable> - A special variable which is a list of lists of values
;;            and maintained as a FIFO. Each component list is the values for the
;;            function at the next stage of the pipeline.
;;   <thread-count> - The number of threads to allocate to this portion of the
;;            pipeline.
;; The "pipe" is established by the <output-queue-variable> for one function
;; being the source of input (i.e. the <input-queue-variable>) for the next part
;; of the pipeline. The final result of the pipeline is the final
;; <output-queue-variable>'s value.
;;
;; WHAT A THREAD DOES
;;   Note: first in pipe - loop until input value = NIL|0
;;   Note: rest of pipe - loop until input value = :done
;;  LOOP FOREVER
;;  acquire input value lock
;;  get input value (decf or pop)
;;  release input value lock
;;
;;  if input :done (or NIL|0 for first in pipe),
;;    then decf t-count, if t-count now 0, output :done (see below), 
;;    else run function and get return values in a list
;;
;;  acquire output value lock
;;   append list of values from function to output value
;;   OR when done (no more work, this is last thread), append :done to output value queue
;;      and end thread (no more work for threads of this component)
;;  release output value lock
;;  END LOOP

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun make-var-lock-sym (var)
    (intern (string-upcase (format NIL "~A-lock" var)))))

(defmacro def-var-lock (var)
  (let ((var-lock-sym (make-var-lock-sym var)))
    `(progn 
       (eval-when (:execute :compile-toplevel :load-toplevel)
	 (defvar ,var-lock-sym))
       (setf ,var-lock-sym (bt:make-lock (string ',var))))))

(defmacro def-locked-var (var &optional value)
  (let ((var-sym (intern (string-upcase (format NIL "~A" var)))))
    `(progn
       (eval-when (:execute :compile-toplevel :load-toplevel)
	 (defvar ,var-sym))
       ,(when value `(setf ,var-sym ,value))
       (def-var-lock ,var-sym))))

(defmacro with-locked-var ((var) &body body)
  (let ((var-lock-sym (make-var-lock-sym var)))
    `(prog2
       (bt:acquire-lock ,var-lock-sym)
       (unwind-protect
	    (progn ,@body)
	 (bt:release-lock ,var-lock-sym)))))

(defmacro with-threaded-pipe (pipe-description)
  (let ((start ()) (finish ()) final)
    (loop for (input ignore output ig-nore)
       in pipe-description
       do (if (member input finish)
	      (setf finish (remove input finish))
	      (push input start))
       (if (member output start)
	   (setf start (remove output start))
	   (push output finish)))
    (setf final (first finish))
    ;; check well-formedness of pipeline: thread-counts > 0, input to output links.
    `(progn
       (when (null ',pipe-description) (error "Pipeline has no components."))
       (loop for component
	  in ',pipe-description
	  unless (and (listp component) (= (length component) 4))
	  do (error "Pipeline component must be a list of length 4.  This component: ~A"
		    component))
       ,@(loop for (input function output thread-count)
	    in pipe-description
	    collect `(let ((in (symbolp ',input))
			   (out (symbolp ',output))
			   (fnc (functionp #',function))
			   (cnt (typep ,thread-count '(integer 0))))
		       (when (member NIL (list in out fnc cnt))
			 (error "In pipe-description, component ~A has errors:~%~
                        ~@[  input-queue-variable fails symbolp: ~A~%~]~
                        ~@[  output-queue-variable fails symbolp: ~A~%~]~
                        ~@[  function fails functionp: ~A~%~]~
                        ~@[  thread-count fails typep (integer 0): ~A~%~]"
				(list ',input ',function ',output ,thread-count)
				(unless in ',input) (unless out ',output)
				(unless fnc ',function) (unless cnt ,thread-count)))))
       (when (or (> (length ',start) 1) (> (length ',finish) 1))
	 (error "Pipe is malformed: ~@[~%  More than one start: ~A~]~
                              ~@[~%  More than one finish: ~A~]~%"
		(when (> (length ',start) 1) ',start) (when (> (length ',finish) 1) ',finish)))
       ;; order pipe, or assume it's ordered???
       ;; initialize pipeline
       ;; locks for input/output special variables
       ,@(loop for component
	    in pipe-description
	    for input = (first component)
	    for thread-count = (fourth component)
	    count 1 into component-number
	    append (list 
		    (unless (eq :start input)
		      `(def-var-lock ,input))
		    `(def-locked-var ,(format nil "T-COUNT-~S" component-number)
			 ,thread-count)))
       (def-var-lock ,final)
       ;; make threads
       ,@(loop for (input function output thread-count) in pipe-description
	    for input-lock = (intern (string-upcase (format nil "~S-lock" input)))
	    for output-lock = (intern (string-upcase (format NIL "~S-lock" output)))
	    for t-count-var = (intern (string-upcase
				       (format nil "t-count-~S" (+ 1 component-number))))
	    for t-count-lock = (intern (string-upcase
					(format nil "t-count-~S-lock" 
						(+ 1 component-number))))
	    count 1 into component-number
	    append 
	    (loop for n from 1 to thread-count
	       collect `(bt:make-thread 
			 (lambda ()
			   (in-package :scipm)
			   (loop for in = (with-locked-var (,input)
					    ,(if (eq component-number 1)
						 `(if (typep ,input 'integer)
						      (prog1 (list ,input) (decf ,input))
						      (pop ,input))
						 `(if (eq :done (first ,input))
						      :done
						      (pop ,input))))
				for finished = ,(if (eq component-number 1)
						    `(if (typep ,input 'integer)
							 (= (first in) 0)
							 (null in))
						    '(eq in :DONE))
				do (if (not finished)
				       ;; not finished
				       (unless (null in) ; ie not component 1 
					                 ; & nothing to work on now
					 (let ((result
						(multiple-value-list (apply #',function in))))
					   (with-locked-var (,output)
					     (setf ,output (append ,output (list result))))))
				       ;; finished
				       (let ((t-count
					       (with-locked-var (,t-count-var)
						  (decf ,t-count-var))))
					 ;; this is the last thread,
					 ;; append :done to output
					 (when (> 1 t-count)
					   (with-locked-var (,output)
					     (setf ,output (append ,output '(:done)))))
					 ;; end this thread, no more work for it.
					 (return)))))
			 :name ,(format NIL "Component:~A;Thread:~A" component-number n))))
       ;; look for end condition
       (loop until (eq :done 
		       (with-locked-var (,final)
			 (first (last ,final)))))
       ;; return accumulated values as a list of lists
       (butlast ,final))))

;;; Examples:
;;; what I don't like - explicitly defvar'ing anything, much less having to setf their values
;;; what I'd like - (a) first value is the input to the pipeline,
;;;                     remaining n values are list of function and number of threads
;;;                 (b) gensym'ing the "defvar"s would mean no collision between pipelines
;;;                     so you could have pipelines within pipelines
;;; MORE - control on total threads, adding more threads to end of line as beginning folds up
#+EXAMPLE
(progn (defvar *start*)
       (defvar *mid*)
       (defvar *finish*)
       (setf *start* 5
	     *mid* ()
	     *finish* ())
       (with-threaded-pipe
	   ((*start*
	     (lambda (x) (format T "Component 1 - *START* = ~A~%" x)
		     (sleep 2)
		     (+ x 100))
	     *mid*
	     1)
	    (*mid*
	     (lambda (x) (format T "Component 2 - *MID* = ~A~%" x)
		     (- x 50))
	     *finish*
	     1))))

#+EXAMPLE
(progn (defvar *start*)
       (defvar *mid*)
       (defvar *finish*)
       (setf *start* 5
	     *mid* ()
	     *finish* ())
       (flet ((p1 (x)
		(format T "Component 1 - *START* = ~A~%" x)
		(sleep 2)
		(+ x 100))
	      (p2 (x) (format T "Component 2 - *MID* = ~A~%" x)
		  (- x 50)))
	 (with-threaded-pipe
	     ((*start*
	       p1
	       *mid*
	       1)
	      (*mid*
	       p2
	       *finish*
	       1)))))

;;; f94207687 
;;;