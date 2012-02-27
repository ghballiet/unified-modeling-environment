(in-package :scipm)

(defvar *RESULTS* ())

(defun sim-result+orig-data->csv (sim-result data-sets model-name &optional (stream T))
  (flet ((data-name-strings (data-names use-model-name-p)
	   (let ((model-name-p (and use-model-name-p
				    (not (null model-name)) 
				    (not (string= model-name "")))))
	     (loop for name in data-names
		collect (format NIL "~:[~A-observed~;~A-~A~]" model-name-p name model-name)))))
    (loop for sim-set in sim-result
       for data-set in data-sets
       do (let ((list-form))
	    (push (append (data-name-strings (data-names data-set) nil)
			  (rest (data-name-strings (data-names sim-set) t)))
		  list-form)
	    (loop for orig-data across (data-values data-set)
	       for sim-data across (data-values sim-set)
	       do (push (append (coerce orig-data 'list)
				(rest (coerce sim-data 'list)))
			list-form))
	    (loop for line in (reverse list-form)
	       do (format stream "~{~A ~}~%" line))
	    (format stream "~%~%")))))

(defparameter *results-directory-name* "model-results")
(defparameter *results-directory-path* 
  (loop for dir in (asdf:split-string (getenv "XDG_DATA_DIRS") :separator ":") 
     for sub-dir = (try-directory-subpath dir *results-directory-name*
						:type :directory)
     when sub-dir
     return sub-dir))

(defun save-rerun-file (results directory-pathname)
  (let* ((instance-library-name (keyword-value :instance-library-name results))
	 (generic-library-version (keyword-value :generic-library-version results))
	 (initial-random-state (keyword-value :random-state results))
	 (state-vector (mt19937::random-state-state initial-random-state))
	 (pathname (make-pathname :name "rerun" :type "lisp" :defaults directory-pathname))
	 (nmodels (keyword-value :nmodels results))
	 (sim-routine (keyword-value :sim-routine results))
	 (search-routine (keyword-value :search-routine results))
	 (nrestarts-full (keyword-value :nrestarts-full results))
	 (normalize (keyword-value :normalize results))
	 (filter-results (keyword-value :filter-results results)))
    (with-open-file (stream pathname :direction :output :if-exists :supersede)
      (format stream "(in-package :scipm)~%~%~
                      (let ((random-state-state (coerce ~S~%                            ~
                                             '(simple-array (unsigned-byte 32) (627))))~%     ~
                            (*generic-library-version* ~S))~%   ~
                      (run-scipm-random ~S~%      ~
                         :nmodels ~S~%      ~
                         :sim-routine '~S~%      ~
                         :search-routine '~S~%      ~
                         :nrestarts-full ~S~%      ~
                         :normalize ~S~%      ~
                         :filter-results #'~S~%      ~
                         :given-random-state (mt19937::make-random-object :state random-state-state)))"
	      state-vector
	      generic-library-version
	      instance-library-name
	      nmodels
	      sim-routine
	      search-routine
	      nrestarts-full
	      normalize
	      (multiple-value-bind (x y name) 
		  (function-lambda-expression filter-results)
		(declare (ignore x y))
		name)))))

(defun save-sim-charts (model data-sets sim-data directory-pathname)
  (declare (ignorable model data-sets sim-data directory-pathname))
  (let ((pathname (make-pathname :name (string (model-name model))
				 :type "csv"
				 :defaults directory-pathname)))
    (with-open-file (stream pathname :direction :output)
      (sim-result+orig-data->csv sim-data data-sets (model-name model) stream))))

(defun results-directory-pathname (&optional (results *results*))
  (let ((instance-library-name (string (keyword-value :instance-library-name results)))
	(time-based-name (multiple-value-bind (sec min hr day mn yr x y z) 
			     (decode-universal-time (keyword-value :start-time results))
			   (declare (ignorable x y z))
			   (format nil "~A-~2,'0D-~2,'0D_~2,'0D-~2,'0D-~2,'0D"
				   yr mn day hr min sec))))
    (make-pathname :directory (append (pathname-directory *results-directory-path*)
				      (list instance-library-name time-based-name)))))

(defun save-results (&optional (results *results*))
  (unless (keyword-value :saved-p results)
    (let ((data-sets (keyword-value :data-sets results))
	(model-results (keyword-value :model-results results))
	(current-path (results-directory-pathname results)))
    (ensure-directories-exist current-path)
    (save-rerun-file results current-path)
    (loop for (model params score sim-data) 
       in model-results
       do (when sim-data (save-sim-charts model data-sets sim-data current-path))
	 (save-equations model params score current-path))
    (let ((star-res-path (make-pathname :name "star-results-star" :type "lisp"
					:defaults current-path)))
      (with-open-file (str star-res-path :direction :output)
	(format str "~S" *results*)))
    (setf (second results) T))))

(defun print-result (result &optional stream)
  (let ((model (first result))
	(params (second result))
	(score (third result))
	(sim (fourth result)))
    (declare (ignorable sim score params))
    (format stream "~A~%~A~%SCORE: ~A~%" 
	    (combine-equations (build-equations model T))
	    params
	    score)))

(defun print-nth-result (n &optional (results *results*) (stream T))
  (print-result (nth n (keyword-value :model-results results)) stream))