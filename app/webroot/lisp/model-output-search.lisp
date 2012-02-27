;;;;;;;;;;;;;;;;;;;;;;;;

;; a struct with a string name and a list of strings
;; as entities
(defstruct lite-process
  (name nil)
  (entities nil))

;; use to create the simulation model, outputs
;; simulation results and returns a model
;; struct
;;
;;  should use the p-hash of parameters and the lp-list to do so
;; currently a stub
(defun create-lite-model (lp-list p-hash ents)
  (format t "~S~%" lp-list)
)

;; FIELDS
;; library-file: the filename of the library to be used
;; this-file: the 'run-file' which contains a list of entities
;; entities: a list of entity instances for the search
;; search-method: either dnf or cnf, depending on logic method to generate structures
;; data-files: list of files to fit params to
;;
;; To create a model-output-search use the create-model-output-search function!
(defstruct (model-output-search (:conc-name mos-))
  (library-file nil)
  (this-file nil)
  (entities nil)
  (search-method nil)
  (data-files nil))
  
;; Wrapper for creating libraries.
;; Sets the *current-library* global when created.
(defun create-model-output-search (&key library-file this-file entities search-method
				   data-files)
  (setf  *mos*
	 (make-model-output-search
	  :library-file library-file
	  :this-file this-file
	  :entities entities
	  :search-method search-method
	  :data-files data-files))
  (init-mos))

;; creates and runs the search, then outputs the results to file
(defun init-mos ()
  ;; load the data sets
  (setf *data-sets*  (mapcar #'(lambda (x) (read-data-from-file x))
			     (mos-data-files *mos*)))

  ;; Do the parameter and structural search
  (output-results (exhaustive (create-solution-generator 
			       (mos-entities *mos*)) 
			      *data-sets* 
			      (mos-search-method *mos*))))

;; First, delete any existing 'scipm_output' directory.
;; Next copy the SC-IPM simulation files and supporting files,
;; this should be in a package format
;; Output each of the models and there best simulations.
;;
;; results is in the format (list model param-hash best-score best-sim)
(defun output-results (results)

  (let ((output_path (make-pathname :directory '(:relative "scipm_output")))
	(lite_path (make-pathname :directory '(:relative "scipm_output" "lite")))
	(cur_file)
	(m-count 1)
	(os t); the output stream
	)

    ;; Copy and create the directories for the sc-ipm-lite version
    (copy-sc-ipm-lite output_path lite_path)
    (copy-lib-and-runfile (mos-library-file *mos*) output_path)

        
    ;; output the resulting simulations
    ;; (first x) - a models struct
    ;; (second x) - a parameters hashtable, key is 'process-name'+++'const-name'
    ;; (third x) - the rMSE of the model
    ;; (forth x) - a data object, the simulation results of the parameter fitting
    (mapc #'(lambda (x)
	      (setf os (open (merge-pathnames (concatenate 'string 
							   "model" 
							   (write-to-string m-count) 
							   ".lisp")
					      output_path) :direction :output :if-exists :supersede))
	      (output-header os m-count)
	      (incf m-count)
	      (output-model os (first x))
	      ;;(format t "MODEL:~%~S~%" (first x))
	      ;;(format t "PARAMS:~%~S~%" (second x))
	      (output-params os (second x))
	      (format os ";;;;;; SCORE:~S~%" (third x))
	      ;(format t "SIM:~%~S~%" (fourth x)))
	      (format os ";;;;;; SIMULATION ;;;;;;~%")
	      (mapc #'(lambda (d)
			(print-lisp-commented-data-set d os))
		    (fourth x))
	      ;; now copy the portion of the file from the run file
	      (output-run-file os)
	      ;; output a hashtable for the parameters
	      (output-param-hash os (second x))
	      ;; output the call to recreate the model, and by default simulate the 
	      ;; model using cvode
	      (output-model-create os (first x))
	      (close os)
	      )
	      results)

  nil))


;; m: a model
;; os: and output stream
;;
;; here again I use the 1-1 mapping assumption for the entities to roles
(defun output-model-create (os m)
  (format os "(setf sim-model (create-lite-model (list ")
  (mapc #'(lambda (p) 
	    (format os "(make-lite-process :name \"~a\" :entities (list " (process-name p))
	    (maphash #'(lambda (k v) (format os "\"~a\" " (entity-name (car v)))) (process-entities p))
	    (format os ")) ")) (model-processes m))
  (format os " ) p-hash **entities**))~%")
  )

;; simple output of some lisp code
(defun output-param-hash (os p-hash)
  (format os ";;;;;; param hashtable~%")
  (format os "(setf p-hash (make-hash-table :test #'equal))~%")
  
  (maphash #'(lambda (k v)
	       (format os (concatenate 'string "(setf (gethash \"" k "\" p-hash) " "~d)~%") v))
	   p-hash))

;; this function copies, line for line (skipping comments) 
;; the run-file for the model search, until it reaches a line 
;; which is a comment
;; containing the words 'END' and 'ENTITY' and 'LIST'
;; I know this is borderline retarded, but I can't think of a better
;; balance of work for the user and work for the parser.
;;
;; Also the parser sucks, but I'm not using regexp, only the search function
;; so bleh.
(defun output-run-file (os)
  (let ((is (open (mos-this-file *mos*)))
	(line)
	(stop-flag nil)
	)
    (loop for line = (read-line is nil)
         while line do 
	 (progn ()
		(setf line (string-trim " " line))
		(unless stop-flag
		  ;;check if the line is the stop line
		  (if (and (search "END" line) (search "ENTITY" line) (search "LIST" line))
		      (setf stop-flag t)		      
		      (unless (and (search ";" line) (= (search ";" line) 0))
			(format os "~a~%" line))))))
    (close is)
    )
)

(defun output-params (os p-hash)
  (format os ";;;;;; PARAMETERS ;;;;;;~%")
  (maphash #'(lambda (k v)
	       (format os ";;;;;; ")
	       (format os (concatenate 'string "KEY: " k ", VALUE: ~d") v)
	       (format os " ;;;;;;~%")) p-hash))

;; INPUT
;;   os: output stream
;;   m: model to output
;;
;; just call the print process for all processes in the model,
;; to update how you would like the model to be printed, update print-pi
(defun output-model (os m)
  (format os ";;;;;; PROCESSES ;;;;;;~%")
  (dolist (proc (model-processes m))
    (format os ";;;;;;  ")
    (print-pi proc os)
    (format os "  ;;;;;;~%")))


(defun output-header (os i)
  (format os ";;;;;; MODEL ~d ;;;;;;;~%" i)
  (format os ";;;;;; ~%" i)
  (format os ";;;;;; ~%" i)

)

(defun copy-lib-and-runfile (lib-name out-path)
  (let (is os)
    
    ;;copy the library
    (setf is (open lib-name))
    (setf os (open (merge-pathnames lib-name out-path) 
		   :direction :output :if-exists :supersede))
    (copy-stream is os)
    (close os)
    (close is)
    
    ;; copy sc-ipm-lite
    (setf is (open "sc-ipm-lite.lisp"))
    (setf os (open (merge-pathnames "sc-ipm.lisp" out-path)
		   :direction :output :if-exists :supersede))
    (copy-stream is os)
    (close os)
    (close is)
    (setf is (open "sc-ipm-lite.lisp"))
    (setf os (open (merge-pathnames "sc-ipmc.lisp" out-path)
		   :direction :output :if-exists :supersede))
    (copy-stream is os)
    (close os)
    (close is)

    (setf is (open "cvode_interface.so"))
    (setf os (open (merge-pathnames "cvode_interface.so" out-path)
		   :direction :output :if-exists :supersede))
    (copy-stream is os)
    (close os)
    (close is)
    )
)

  
;; copy supporting lisp files to the 'lite' directory
;; copy sc-ipm-lite file to the 'scipm_output' directory
(defun copy-sc-ipm-lite (out-path lite-path)
  (let (is os)
    ;; delete previous results and create a new directory
    (when (file-directory-p out-path)
      (delete-directory-and-files out-path))
    (make-directory out-path)
    (make-directory lite-path)
    
    ;; create all the required directories
    (dolist (d *dir-list*) (make-directory (merge-pathnames d lite-path)))
    
    ;; now copy all the files for sc-ipm
    (dolist (fn *f-list*)
      (setf is (open fn))
      (setf os (open (merge-pathnames fn lite-path) :direction :output :if-exists :supersede))
      (copy-stream is os)
      (close os)
      (close is))
    
    )

  )

;; copies one stream to another, does not close either stream
(defun copy-stream (from to)
  (let ((buf (make-array 4096 :element-type (stream-element-type from))))
    (do ((pos (read-sequence buf from) (read-sequence buf from)))
        ((= 0 pos) nil)      
      (write-sequence buf to :end pos))))