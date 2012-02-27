(in-package :scipm)

(defmacro run-program (prog-call arg-list name-str)
  `(let* ((error-path (make-pathname :name (format NIL "ERROR-~A" ,name-str)
				     :type "txt"
				     :defaults directory-pathname))
	  (p (sb-ext:run-program ,prog-call
				 ,arg-list
				 :error error-path
				 :if-error-exists :supersede))
	  (exit-code (sb-ext:process-exit-code p)))
     (unless (= exit-code 0)
       (format *error-output* ">>>>> ~A exit code: ~A~%~
                               >>>>> for arglist ~A~%"
	       ,name-str exit-code ,arg-list))))

;;;

(defvar *clean-up-plot-files* T)

(defun recorded-entities (data-file-path)
  (let ((header (with-open-file (s data-file-path :direction :input)
		  (read-line s)))
	(x 0)
	(y nil) z)
      (loop until (eq z :EOF) 
	 do (multiple-value-bind (obj start)
		(read-from-string header nil :EOF :start x)
	      (if (eq obj :eof)
		  (setf z :eof)
		  (progn (setf x start) (push obj y)))))
      (reverse y)))

(defun generate-plot-doc (doc-file-name-path plot-file-name-str)
  (with-open-file (stream doc-file-name-path 
			  :direction :output 
			  :if-exists :supersede)
    (format stream "% !TEX TS-program = pdflatex~%~
                    % !TEX encoding = UTF-8 Unicode~%~

                    \\documentclass[11pt]{article}~%~
                    \\usepackage[utf8]{inputenc}~%~

                    %%% PAGE DIMENSIONS~%~
                    \\usepackage{geometry}~%~
                    \\geometry{letterpaper}~%~

                    %%% PACKAGES~%~
                    \\usepackage{amsmath}~%~
                    \\usepackage[retainorgcmds]{IEEEtrantools}~%~
                    \\usepackage{graphicx}~%~

                    \\begin{document}~%~

                    \\begin{figure}~%~
                    \\include{\"~A\"}~%~
                    \\end{figure}~%~

                    \\end{document}~%"
		    plot-file-name-str)))
(defun end-observed-data-index (recorded-entity-list)
  (1+ (loop for x
	 in recorded-entity-list
	 when (and (< (length "-observed") (length x))
		   (search "-observed" x :from-end t :test #'string-equal 
			   :start2 (- (length x) (length "-observed"))))
	 count 1)))

(defun plot-model-simulation (model-name directory-pathname
			      &optional (entity-list :all) (observed-data-p t) 
			      (force NIL) (tex-p NIL))
  (flet ((file-name-suffix ()
	   (if (or (eq entity-list :all) (and (listp entity-list)
					      (= 0 (length entity-list))))
	       (format NIL "all~{-~A~}" 
		       (when observed-data-p '("obsvd")))
	       (format NIL "~A~{-~A~}~{-~A~}"
		       (first entity-list) 
		       (rest entity-list)
		       (when observed-data-p '("obsvd")))))
	 (using-with-title-string (data-file-path)
	   (let* ((recorded-entity-list (loop for x in (recorded-entities data-file-path)
					   collect (string x)))
		  (entity-number-pairs (loop for entity in recorded-entity-list
					  for x from 1 to (length recorded-entity-list)
					  collect `(,entity ,x)))
		  (start-sim-idx (end-observed-data-index recorded-entity-list))
		  (sim-entities-idx (subseq entity-number-pairs start-sim-idx))
		  (obs-entities-idx (if observed-data-p 
					(subseq entity-number-pairs 1 (1- start-sim-idx))))
		  (indices
		   (cond ((and (eq :all entity-list) observed-data-p)
			  (loop for x from 2 to (length recorded-entity-list)
			     append `(,x ,x)))
			 ((and (eq :all entity-list) (not observed-data-p))
			  (loop for x from start-sim-idx to (length recorded-entity-list)
			     append `(,x ,x)))
			 (t (loop for entity-idx-list
			       in `(,obs-entities-idx ,sim-entities-idx)
			       append (loop for entity 
					 in entity-list
					 append
					 (let ((e-i (first
						     (member-if 
						      #'(lambda (x) 
							  (string-equal 
							   entity
							   (subseq x 0 (length entity))))
						      entity-idx-list
						      :key #'first))))
					   (when e-i `(,(second e-i) ,(second e-i))))))))))
	     (setf indices (sort indices #'<))
	     (format t "~%~A" start-sim-idx)
	     (format NIL "using 1:~A with linesp title columnhead(~A)~
                          ~{, '' using 1:~A with linesp title columnhead(~A)~}" 
		     (first indices) (second indices) (cddr indices)))))
    (unless directory-pathname
      (setf directory-pathname (results-directory-pathname *results*)))
    (if tex-p ;; GENERATE PLOT FILES
	(let* ((file-name-suffix (file-name-suffix))
	       (data-file-path (make-pathname :name model-name 
					      :type "csv" 
					      :defaults directory-pathname))
	       (data-file-path-string (pathname-string data-file-path))
	       (plot-file-name-str (format NIL "~A-plot-~A" model-name file-name-suffix))
	       (plot-file-path-str (pathname-string
				    (make-pathname :name plot-file-name-str
						   :type "tex"
						   :defaults directory-pathname)))
	       (doc-file-name-str (format NIL "~A-doc-~A" model-name file-name-suffix))
	       (doc-file-name-path (make-pathname :name doc-file-name-str
						  :type "latex"
						  :defaults directory-pathname))
	       (doc-file-path-str (pathname-string doc-file-name-path)))
	  ;; unless force, check if exists "<model-name>-doc-<vars>-[obsvd].pdf"
	  (let ((pdf-pathname (make-pathname :name doc-file-name-str
					     :type "pdf"
					     :defaults directory-pathname)))
	    (when (or force (not (probe-file pdf-pathname)))
	      ;; generate plot "<model-name>-plot-<vars>-[obsvd].latex"
	      (let ((plot-command-string (format NIL "set terminal epslatex; ~
                                        set key bmargin nobox; ~
                                        set output '~A'; ~
                                        plot '~A' ~A"
						 plot-file-path-str
						 data-file-path-string
						 (using-with-title-string data-file-path))))
		(run-program "/usr/local/bin/gnuplot"
			     `("-persist" "-e" ,plot-command-string)
			     "gnuplot")
		;; generate plot doc "<model-name>-doc-<vars>-[obsvd].latex"
		(generate-plot-doc doc-file-name-path plot-file-name-str)
		;; create pdf file "<model-name>-doc-<vars>-[obsvd].pdf"
		(run-program "/usr/texbin/pdflatex"
			     `("-shell-escape" 
			       "-output-directory"
			       ,(format NIL "~A" (pathname-string directory-pathname))
			       ,(format NIL "~A" doc-file-path-str))
			     "pdflatex")))
	    ;; open pdf file
	    (run-program "/usr/bin/open" (list (pathname-string pdf-pathname)) "open")
	    ;; clean up excess files
	    (when *clean-up-plot-files*
	      (let ((doc-aux (make-pathname :name doc-file-name-str
					    :type "aux"
					    :defaults directory-pathname))
		    (doc-log (make-pathname :name doc-file-name-str
					    :type "log"
					    :defaults directory-pathname))
		    (plot-aux (make-pathname :name plot-file-name-str
					     :type "aux"
					     :defaults directory-pathname))
		    (plot-converted-pdf (make-pathname :name (format NIL "~A-~A" 
								     plot-file-name-str
								     "eps-converted-to")
						       :type "pdf"
						       :defaults directory-pathname)))
		(loop for file in (list doc-aux doc-log plot-aux plot-converted-pdf)
		   when (probe-file file)
		   do (delete-file file))))))
	;; NOT tex'd - just put up an x11 window with the plot
	(let* ((data-file-path (make-pathname :name model-name
					      :type "csv" 
					      :defaults directory-pathname))
	       (data-file-path-string (pathname-string data-file-path))
	       (plot-command-string (format NIL "set terminal x11; ~
                                        set key bmargin nobox; ~
                                        plot '~A' ~A"
					    data-file-path-string
					    (using-with-title-string data-file-path))))
	  (format T "~%~A" plot-command-string)
	  (run-program "/usr/local/bin/gnuplot"
		       `("-persist" "-e" ,plot-command-string)
		       "gnuplot")))))