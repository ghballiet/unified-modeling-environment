(in-package :scipm)

;;; the functions for reading and storing data files

;; data files will consist of whitespace delimited values
;; the amount of whitespace doesn't matter
;; the first line contains the variable names
;; any non-numeric values past the first line will be considered missing
;; values will be stored "as-is" into the data structure

(defstruct data ;(data (:print-object print-data-set))
  names     ; list of variable names
  values    ; vector of samples, where each sample is a vector
  id-name   ; the name of the primary identification variable (e.g., time)
)
(defun print-data-set  (d &optional (stream t))
  (format stream "~A~%" (data-names d))
  (dotimes (idx (data-length d) t)
    (let ((vals (svref (data-values d) idx)))
      (dotimes (dex (- (length vals) 1) t)
	(format stream "~6,6F " (svref vals dex)))
      (format stream "~6,6F~%" (svref vals (- (length vals) 1)))))
  )

(defun print-lisp-commented-data-set (d &optional (stream t))
  (format stream ";; ")
  (dotimes (i (- (length (data-names d)) 1) t)
    (format stream "~A~T" (nth i (data-names d))))
  (format stream "~A~%"  (nth  (- (length (data-names d)) 1) (data-names d)))
  (dotimes (idx (data-length d) t)
    (format stream ";; ")
    (let ((vals (svref (data-values d) idx)))
      (dotimes (dex (- (length vals) 1) t)
	(format stream "~6,6F~T" (svref vals dex)))
      (format stream "~6,6F~%" (svref vals (- (length vals) 1)))))
  )



;;;;; Functions for reading data from a stream ;;;;;

;;; input: a string
;;; output: the string with trailing whitespace removed
(declaim (inline strip-end-whitespace))
(defun strip-end-whitespace (s)
  (string-right-trim '(#\Tab #\Return #\Space #\Newline) s))

;;; input: a stream
;;; output: a string representation of the first non-blank line in a stream
;;; notes: strips trailing white space from the string
(defun next-line (str)
   (do ((s (strip-end-whitespace (read-line str nil "eof"))
           (strip-end-whitespace (read-line str nil "eof"))))
       ((string/= "" s) s)))

;;; input: a stream and an end token
;;; output: a list of non-empty, string-formatted lines from the stream
;;; notes: trailing whitespace is stripped from the string
(defun strip-blank-lines (str &optional (token "eof"))
   (do ((s (next-line str) (next-line str))
        (lst))
       ((or (string-equal s token)
            (string-equal s "eof"))
        (nreverse lst))
      (setf lst (cons s lst))))

;;; input: a stream containing trajectories for one or more variables
;;; output: a "data" structure that contains the information from the stream
(defun read-data (str)
  (let* ((anames (read-from-string (format nil "(~A)" (next-line str))))
         (vlst (strip-blank-lines str))
         (avlst (mapcar #'(lambda (x)
			    (apply #'vector 
				   (read-from-string
				    (format nil "(~A)" x))))
			vlst)))
    (make-data
     :names  anames
     :values (apply #'vector avlst))))

;;; input: a file name
;;; output: a data set
(defun read-data-from-file (fname &optional directory)
  (let ((pathname (if (stringp fname)
		      (make-pathname :name fname :directory directory)
		      fname)))
    (with-open-file (str pathname :direction :input) (read-data str))))


;;;;; Functions for accessing data ;;;;;

;; input: data set
;; output: number of entries in the data set
;(declaim (inline data-length))
(defun data-length (dset)
  (array-dimension (data-values dset) 0))


;;; input: data set and an index
;;; output: the sample vector at the given index of the data set
;(declaim (inline datum))
(defun datum (dset idx)
  "Returns the datum at the specified index in the given dataset."
  (svref (data-values dset) idx))

;;; input: a sample vector and a variable name
;;; output: the value of the specified variable in the datum.
;(declaim (inline datum-value))
(defun datum-value (dtm aname dataset)
  "Returns the value for the specified attribute in the given datum."
  (svref dtm (position aname (data-names dataset))))

;; assumes that the data-id-name field indicates the column name for
;; time or is nil.  if it's nil, then it assumes that the first
;; column is the time column.
;(declaim (inline datum-time))
(defun datum-time (dset idx)
  "Returns the time associated with the current set of observations."
  (let ((time-index (if (data-id-name dset) 
			(position (data-id-name dset) (data-names dset))
			0)))
    (svref (svref (data-values dset) idx) time-index)))
  
;; takes a time and returns the index to the datum sampled at the
;; closest time without going over the given value
;(defvar *tcounter* 0)
(defun t-to-index (time data)
;  (incf *tcounter*)
  (t-to-index-finder time data 0 (- (length (data-values data)) 1)))

;; binary search for the given time
(defun t-to-index-finder (time data start end)
  (let ((mid (+ start (floor (/ (- end start) 2)))))
    (cond ((< time (datum-time data start))
	   start)
	  ((> time (datum-time data end))
	   end)
	  ((= time (datum-time data mid))
	   mid)
	  ((< time (datum-time data mid))
	   (t-to-index-finder time data start (- mid 1)))
	  (t
	   (t-to-index-finder time data (+ mid 1) end)))))


;; calculate and store a measure of the dispersion of values in a data
;; set for use during normalization
(let ((disp-ht (make-hash-table)))
  ;; assume: all data sources have the same variables as the first
  (defun calculate-dispersions (data-lst)
    (dolist (v (data-names (car data-lst)))
      (setf (gethash v disp-ht) (disp-variance v data-lst))))
  
  (defun disp-variance (v data-lst)
    (let ((sx 0d0) (sxx 0d0) (dlen 0))
      (dolist (dset data-lst)
	(incf dlen (data-length dset))
	(dotimes (idx (data-length dset))
	  (let ((val (datum-value (datum dset idx) v dset)))
	    (incf sx val)
	    (incf sxx (* val val)))))
      (- sxx (/ (* sx sx) dlen))))
  
  (defun data-dispersions ()
    disp-ht))