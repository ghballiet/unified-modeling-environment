(in-package :scipm)

;;;;;;;;;;
(defun dotted-list-p (x)
  "Predicate which returns T if something is a dotted list.
 NIL is NOT a dotted list!"
  (and (listp x)(dotted-pair-p (last x))))

(defun dotted-pair-p (X)
  (and (listp x)(null (listp (cdr x)))))

(defun but-last (list)
  (reverse (cdr (reverse list))))

(defun pathname-string (pathname)
  (format NIL "~A" pathname))
;;;;;;;;;

(defvar *equation-print-level* -1)
(defvar *suppress-paren* NIL)
(defvar *eq-agg-environ* NIL)
(defvar *current-process-obj* NIL)
(defvar *clean-up-eqs-files* T)

;;; set next so output uses process's entity role id for RHS entity name,
;;; rather than the entity's type. Role id: P vs. entity name: Aurelia
(defvar *abbrev-entity-by-process-role* T)

;;;;;;;;;

(defun escape-latex-chars (char-list string)
  (let ((str (make-array '(0) :element-type 'base-char
			 :fill-pointer 0 :adjustable t)))
    (with-output-to-string (s str)
      (loop for i from 0 to (1- (length string))
	 do (let ((c (aref string i)))
	      (cond ((member c char-list :test #'equal)
		     (format s "\\~C" c))
		    (T (format s "~C" c))))))
    str))

(defun latex-equation-header (&optional (stream t))
  (format stream "% !TEX TS-program = pdflatex~%~
                  % !TEX encoding = UTF-8 Unicode~%~%~
                  \\documentclass[11pt]{article}~%~
                  \\usepackage[utf8]{inputenc}~%~%~
                  %%% PAGE DIMENSIONS~%~
                  \\usepackage{geometry}~%~
                  \\geometry{margin=0.25in}~%~
                  \\geometry{letterpaper}~%~%~
                  \\interdisplaylinepenalty=0~%~%~
                  %%% PACKAGES~%~
                  \\usepackage{amsmath}~%~
                  \\begin{document}"))

(defun latex-equation-eof (&optional (stream t))
  (format stream "\\end{document}"))

(defmethod latex-object ((object string) params &optional (stream t))
  (cond ((string= "*" object) (format stream "\\: \\cdot \\:"))
	((string= "+" object) (format stream "\\: + \\:"))
	(T (format stream "~A" object))))

(defmethod latex-object ((object symbol) params &optional (stream t))
  (latex-object (string object) params stream))

(defmethod latex-object ((object integer) params &optional (stream t))
  (format stream "~D" object))

(defmethod latex-object ((object number) params &optional (stream t))
  (format stream "~D" object))

(defmethod latex-object ((object process) params &optional (stream t))
  (declare (ignore params))
  (let ((process-string (escape-latex-chars '(#\{ #\} #\_) (print-pi object NIL))))
    (format stream "~A" process-string)))

(defmethod latex-object ((object entity) params &optional (stream t))
  (declare (ignore params))
  #+DEBUG-ENTITY-LATEX
  (format T "~%*current-process-obj* :: ~A~%~
             *abbrev-entity-by-process-role* :: ~A~%~
             entity :: ~A~%~
             process-entity-roles :: ~A~%~
             member :: ~A~%"
	  *current-process-obj* *abbrev-entity-by-process-role* object
	  (when  *current-process-obj*
	    (process-entity-roles *current-process-obj*))
	  (when  *current-process-obj*
	    (member object (process-entity-roles *current-process-obj*)
					  :key #'caadr :test #'equal)))
  (let ((entity-string (escape-latex-chars
			'(#\{ #\} #\_) 
			(if (and *current-process-obj* *abbrev-entity-by-process-role*)
			    (caar (member object (process-entity-roles *current-process-obj*)
					  :key #'caadr :test #'equal))
			    (entity-name object)))))
    (format stream "~A" entity-string)))

(defvar *h-space* nil)

(defmethod latex-object ((object constant?) params &optional (stream t))
  (declare (ignore params))
  (format stream "\\emph{~{~A~}~A}" *h-space* (escape-latex-chars '(#\_) (constant-type-name (constant?-type object)))))

(defmethod latex-object ((object variable?) params &optional (stream t))
  (declare (ignore params))
  (format stream "\\emph{~{~A~}~A}" *h-space* (escape-latex-chars '(#\_) (variable-type-name (variable?-type object)))))

(defmethod latex-object ((object list) params &optional (stream t))
  (incf *equation-print-level*)
  (cond ((dotted-pair-p object)
	 ;; this is a variable or constant
	 (latex-object (cdr object) params stream)
	 (unless (process-p (car object))
	   (format stream "_\\text{")
	   (latex-object (car object) params stream)
	   (format stream "}")))
	((and (listp (first object)) (eq :GP (first (first object))))
	 ;; this is an element (attributable to a process)
	 (format stream "~%\\underbrace{")
	 (let ((*suppress-paren* (= 1 (length (rest object))))
	       (*current-process-obj* (second (first object))))
	   (latex-object (rest object) params stream) ; elements
	   (format stream "}_\\text{~A}"              ; process
		   (escape-latex-chars 
		    '(#\_ #\{ #\})
		    (format NIL "~A" (second (first object)))))))
	((eq 'EQUATION-AGGREGATOR (first object))
	 ;; this is collection of elements
	 (let* ((*eq-agg-environ* T)
		(op-func (second object))
		(op (cond ((eql op-func #'+) "+")
			  ((eql op-func #'*) "\\cdot")
			  ((eql op-func #'min) "\\min")
			  ((eql op-func #'max) "\\max"))))
	   (if (or (eql op-func #'+) (eql op-func #'*))
	       ;; infix operators
	       (let ((*suppress-paren* (= 1 (length (cddr object)))))
		 (loop for obj
		    in (but-last (cddr object))
		    do	  ;(setf *equation-print-level* :new-element) 
		    (latex-object obj params stream)
		    ;; an attempt to do conditional line break
		    (format stream "\\\\~%&~A \\: " op))
		 (latex-object (car (last object)) params stream))
	       ;; prefix operators
	       (progn (format stream "~A{\\: \\big[\\:" op)
		      (loop for obj
			 in (but-last (cddr object))
			 do (latex-object obj params stream)
			 (format stream ",\\: "))
		      (latex-object (car (last object)) params stream)
		      (format stream "\\:\\big]}")))))
	(T
	 ;; this is a sub-element
	 ;; TO DO: op printing; binary v. unary op
	 (multiple-value-bind (op type)
	     (op-latex-str-and-type (first object))
	   (case type
	     (:log (progn (format stream "~A_{" op)
			  (latex-object (or (third object) 10) params stream)
			  (format stream "}")
			  (latex-object (second object) params stream)))
	     (:binary  (let ((no-parens (or *suppress-paren*
					    (and (= 1 *equation-print-level*)
						 (not *eq-agg-environ*)))))
			 (unless no-parens
			   (format stream "\\big("))
			 (loop for obj
			    in (but-last (rest object))
			    do (latex-object obj params stream)
			    (if (string-equal op "^")
				(format stream "~A" op)
				(format stream "\\: ~A \\:" op)))
			 (if (string-equal op "^")
			   (let ((*h-space* (list "\\:\\: ")))
			     (latex-object (car (last object)) params stream))
			   (latex-object (car (last object)) params stream))
			 (unless no-parens (format stream "\\big)"))))
	     (:unary ;; assume list of length 2 - operator and operand
	      (cond  ((string-equal op "e^")
		      (format stream "~A{\\scriptstyle{" op)
		      (latex-object (second object) params stream)
		      (format stream "}}"))))
	     (:prefix-binary ;; assume list of length 3 - operator and two operands
	      (format stream (first op))
	      (let ((*equation-print-level* 0))
		(latex-object (second object) params stream))
	      (format stream (second op))
	      (let ((*equation-print-level* 0))
		(latex-object (third object) params stream))
	      (format stream (third op)))
	     (:min-max
	      (format stream "~A{\\: \\big[\\:" op)
	      (loop for obj
		 in (but-last (rest object))
		 do (latex-object obj params stream)
		   (format stream ",\\: "))
	      (latex-object (first (last object)) params stream)
	      (format stream "\\:\\big]}"))))))
  (decf *equation-print-level*))

(defun op-latex-str-and-type (op-str)
  (cond ((string-equal op-str "*")
	 (values "\\cdot" :binary))
	((member op-str '("-" "+") :test #'string-equal)
	 (values op-str :binary))
	((string-equal op-str "EXP")
	 (values "e^" :unary))
	((string-equal op-str "EXPT")
	 (values "^" :binary))
	((string-equal op-str "/")
	 (values '("\\cfrac{" "}{" "}") :prefix-binary))
	((string-equal op-str "max")
	 (values "\max" :min-max))
	((string-equal op-str "min")
	 (values "\min" :min-max))
	((string-equal op-str "log")
	 (values "\log" :log))))

(defmethod latex-object ((object differential-equation) params &optional (stream t))
  (format stream "{\\displaystyle \\frac{\\text{d}\\!\\!\\left[")
 ; (print (diff-eq-variable object)) (print (type-of (diff-eq-variable object)))
  (latex-object (diff-eq-variable object) params stream)
  (format stream "\\right]}{\\text{d}t}}= &")
  (latex-object (diff-eq-rhs object) params stream)
  (format stream "\\displaybreak[0]\\\\~%"))

(defmethod latex-object ((object algebraic-equation) params &optional (stream t))
  (latex-object (alg-eq-variable object) params stream)
  (format stream "= &")
  (latex-object (alg-eq-rhs object) params stream)
  (format stream "\\displaybreak[0]\\\\~%"))

(defun model-rhs-list (model)
  (loop for (nil eq-list)
     in (build-equations model)
     append (loop for eq
	       in eq-list
	       collect (equation-rhs eq))))

(defun rhs-c?-v? (rhs)
  (let ((constants?-list ())
	(variables?-list ()))
    (loop for x 
       in rhs
       do (cond ((dotted-pair-p x)
		 (if (constant?-p (cdr x))
		     (push x constants?-list)
		     (push x variables?-list)))
		((listp x) 
		 (multiple-value-bind (c?-list v?-list)
		     (rhs-c?-v? x)
		   (setf constants?-list (append constants?-list c?-list)
			 variables?-list (append variables?-list v?-list))))))
    (values (remove-duplicates constants?-list)
	    (remove-duplicates variables?-list))))

(defun model-eqs-c?-v? (model)
  (let ((c?-list ())
	(v?-list ()))
    (loop for rhs
       in (model-rhs-list model)
       do (multiple-value-bind (clist vlist)
	      (rhs-c?-v? rhs)
	    (setf c?-list (append c?-list clist)
		  v?-list (append v?-list vlist))))
    (values (remove-duplicates c?-list)
	    (remove-duplicates v?-list))))

(defun process-entity-parameters (model params)
  (let ((actual-c? (model-eqs-c?-v? model)))
    (remove nil 
	    (loop for x
	       in params
	       collect (let ((member (member (first x) actual-c? 
					     :test #'equal :key #'cdr)))
			 (when member
			   (list (car (first member)) 
				 (cdr (first member))
				 (cdr x))))))))

(defun latex-model-param-value-table (model params &optional (stream t))
  (loop for (object name value)
     in (process-entity-parameters model params)
     do (format stream "$\\text{~A} :: \\text{~A} = ~6,4,1E$\\\\~%"
		(latex-object object params NIL)
		(escape-latex-chars '(#\_) (constant-type-name (constant?-type name)))
		value)))

(defun print-result-latex (model params score &optional (stream t))
  (let ((eqs (combine-equations (build-equations model t))))
    (format stream "{\\Large ~A :: Score = ~6,4,1E}~%" (model-name model) score)
    (format stream "\\quad\\\\~%\\hrule~%\\quad\\\\~%\\emph{{\\large Equations}}\\\\~%")
    (format stream "\\begin{align*}~%")
    (loop for equation 
       in eqs
       do (latex-object equation params stream))
    (format stream "\\end{align*}~%"))
  (format stream "\\hrule~%\\quad\\\\~%{\\emph{{\\large Parameters}}\\\\~%")
  (latex-model-param-value-table model params stream)
  (format stream "\\hrule~%"))

(defun save-equations (model params score directory-pathname)
  (let* ((file-name (format NIL "~A-~A" (string (model-name model)) "eqs"))
	 (pathname (make-pathname :name file-name
				  :type "latex"
				  :defaults directory-pathname)))
    ;; write latex to file
    (with-open-file (stream pathname :direction :output
			    :if-exists :supersede)
      (latex-equation-header stream)
      (print-result-latex model params score stream)
      (latex-equation-eof stream))
    ;; latex to pdf
    (run-program "/usr/texbin/pdflatex" 
		 (list "-output-directory" (pathname-string directory-pathname) 
		       (pathname-string pathname))
		 "pdflatex")
    (when *clean-up-eqs-files* 
      (let ((log-path (make-pathname :name file-name
				     :type "log"
				     :defaults directory-pathname))
	    (aux-path (make-pathname :name file-name
				     :type "aux"
				     :defaults directory-pathname)))
	(when (probe-file log-path) (delete-file log-path))
	(when (probe-file aux-path) (delete-file aux-path))))))

(defun show-model-equations (model-name
			     &optional
			     (directory-pathname (results-directory-pathname *results*)))
  (run-program "/usr/bin/open" 
	       (list (pathname-string (make-pathname
				       :name (format NIL "~A-~A" (string model-name) "eqs")
				       :type "pdf"
				       :defaults directory-pathname)))
	       "open"))

;;;;;

;;; list of process 

