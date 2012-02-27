(in-package :scipm)

(defun keyword-value (key k-v-list)
  (let ((position (position key k-v-list)))
    (when position (nth (1+ position) k-v-list))))

(defun make-variable-hash (variable-list ge)
  (labels ((type-to-generic-variable (var-defn)
	     (loop for (k v) 
		on var-defn
		by #'cddr
		append (list k (case k 
				 (:type (gethash v (generic-entity-variables ge)))
				 (otherwise v))))))
    (let ((vhash (make-hash-table :test #'equal)))
      (loop for variable-defn in variable-list
	 for var-key = (keyword-value :type variable-defn)
	 for fixed-variable-defn = (type-to-generic-variable
				    (values-to-double-float variable-defn
							    :upper-bound
							    :lower-bound
							    :initial-value))
	 for variable = (apply #'make-variable? fixed-variable-defn)
	 do (setf (gethash var-key vhash) variable))
      vhash)))

#+debug (setf variable-list-one '((:type "conc"
				   :aggregator 'sum
				   :data-name "nasutum"
				   :lower-bound 0.001
				   :upper-bound 0.8)
				  (:type "grazing_rate"
				   :aggregator 'sum)))

(defun make-constant-hash (constant-list ge)
  (labels ((type-to-generic-constant (const-defn)
	     (loop for (k v) 
		on const-defn
		by #'cddr
		append (list k (case k 
				 (:type (gethash v (generic-entity-constants ge)))
				 (otherwise v))))))
    (let ((chash (make-hash-table :test #'equal)))
      (loop for constant-defn in constant-list
	 for constant-key = (nth (1+ (position :type constant-defn)) constant-defn)
	 for fixed-constant-defn = (type-to-generic-constant
				    (values-to-double-float constant-defn
							    :upper-bound
							    :lower-bound
							    :initial-value))
	 for constant = (apply #'make-constant? fixed-constant-defn)
	 do (setf (gethash constant-key chash) constant))
      chash)))

#+debug (setf constant-list-one '((:type "assim_eff")
				  (:type "gmax")
				  (:type "gcap")
				  (:type "attack_rate")))

#|
generic-library :: ( generic-library-desc )
generic-library-desc :: ( :name string
		        [ :version number ]
			[ :modify-constraints ( [ constraint-name-symbol |
                                                  constraint-defn ]* ) ]
			[ :modify-entities ( entity-defn* ) ]
			[ :modify-processes ( [ process-name-string | process-defn ]* ) ] )
entities :: ( entity-instance-defn+ )
entity-instance-defn :: ( :name string
		          :generic-type string
		          :variables ( variable-instance-defn* )
		          :constants ( constant-instance-defn* )
		          :comment string )
variable-instance-defn :: ( :type string
		          [ :initial-value float ]
			  [ :upper-bound float ]
			  [ :lower-bound float ]
			  [ :comment string ]
			  [ :units string ]
		            :data-name string
			  [ :exogenous boolean <= default false ]
			  [ :aggregator sum | prod | min | max ] )     <= default sum

constant-instance-defn :: ( :type string
		          [ :initial-value float ]
			  [ :upper-bound float ]
			  [ :lower-bound float ]
			  [ :comment string ]
			  [ :units string ] )
|#

(defun prepare-entity-instance-args (entity-instance-defn generic-library)
  (let ((ge (loop for (k v) 
	       on entity-instance-defn
	       by #'cddr 
	       when (eq k :generic-type)
	       return (find-generic-entity v generic-library))))
    (loop for (k v) 
       on entity-instance-defn
       by #'cddr
       append (case k
		(:name (list k v))
		(:generic-type (list :generic-entity ge))
		(:variables (list k (when v (make-variable-hash v ge))))
		(:constants (list k (when v (make-constant-hash v ge))))
		(:comment (list k v))))))

#+debug (setf entity-instance-defn-one '(:name "nasutum"
					 :generic-type "grazer"
					 :variables ((:type "conc"
						      :aggregator 'sum
						      :data-name "nasutum")
						     (:type "grazing_rate"
						      :aggregator 'sum))
					 :constants ((:type "assim_eff")
						     (:type "gmax")
						     (:type "gcap")
						     (:type "attack_rate"))))

(defparameter *instances-directory-name* "instance-libraries")
(defparameter *instance-file-type* "ilib")
(defparameter *instance-library-path* 
  (loop for dir in (asdf:split-string (getenv "XDG_DATA_DIRS") :separator ":") 
     for sub-dir = (try-directory-subpath dir *instances-directory-name*
						:type :directory)
     when sub-dir
     return sub-dir))

(defparameter *data-files-directory-name* "data-files")
(defparameter *data-file-type* "data")
(defparameter *data-files-path*
  (loop for dir in (asdf:split-string (getenv "XDG_DATA_DIRS") :separator ":") 
     for sub-dir = (try-directory-subpath dir *data-files-directory-name*
						:type :directory)
     when sub-dir
     return sub-dir))

;;; DON'T USE THIS; IT'S MEANINGLESS - just so library-setup doesn't complain
(defvar *instance-library-version* nil)

(defstruct instance-library
  (version nil)
  (modified nil)
  (name nil)
  (generic-library nil)
  (data-files nil)
  (entities nil))

(library-setup instance)

(defun modify-constraint (constraint-mod-list lib)
  (loop for constraint-desc
     in constraint-mod-list
     do (if (and (symbolp constraint-desc)
		 (find constraint-desc (lib-constraints lib)
		       :test #'(lambda (x) (eq (constraint-name x) constraint-desc))))
	    (setf (lib-constraints lib)
		  (delete-if #'(lambda (x) (eq (constraint-name x) constraint-desc))
			     (lib-constraints lib)))
	    (let* ((new-constraint 
		    (apply #'make-constraint
			   (prepare-constraint-args constraint-desc
						    (lib-processes lib))))
		   (remaining-constraints 
		    (delete-if
		     #'(lambda (x) (eq (constraint-name x) (constraint-name new-constraint)))
		     (lib-constraints lib))))
	      (when new-constraint
		(setf (lib-modified lib) T
		      (lib-constraints lib) (append (list new-constraint)
						    remaining-constraints)))))))

(defun modify-entity (entity-mod-list lib)
  ;; no point to removing entities, so we just replace or add
  (let* ((new-entities (make-entities entity-mod-list))
	 (new-entity-types (loop for entity
			      in new-entities
			      collect (generic-entity-type entity)))
	 (remaining-entities (loop for entity
				in (lib-entities lib)
				unless (member (generic-entity-type entity) new-entity-types
					       :test #'string-equal)
				collect entity)))
    (when new-entities
      (setf (lib-modified lib) T
	    (lib-entities lib) (append new-entities remaining-entities)))))

(defun modify-process (process-mod-list lib)
  (loop for item 
     in process-mod-list
     do (if (stringp item)
	    (remove-process-from-library item lib)
	    ;; should be a process-defn
	    (let* ((new-process
		    (apply #'create-generic-process
			   (prepare-process-args item (lib-entities lib))))
		   (process-name (process-name new-process)))
	      ;; replace or add new-process - but leave constraints unchanged
	      (remove-process-from-library process-name lib NIL)
	      (setf (lib-processes lib)
		    (append (list new-process) (lib-processes lib)))))))

(defun prepare-generic-library (generic-library-desc)
  (let ((library (generic-library (keyword-value :name generic-library-desc)
				  (keyword-value :version generic-library-desc))))
    (flet ((modify-library-item (key mod-func)
	     (let ((value (keyword-value key generic-library-desc)))
	       (when value (funcall mod-func value library)))))
      ;; modify library per librar-desc-args
      (loop for (desc-key modification-function)
	 in '(; (:ignore-processes remove-process-from-library)
	      (:modify-entities modify-entity)
	      (:modify-processes modify-process)
	      (:modify-constraints modify-constraint))
	 do (modify-library-item desc-key modification-function)))
    library))

(defmacro create-instance-library (name &key generic-library data-file-list entities)
  `(let* ((current-library (prepare-generic-library ',generic-library))
	  (entities (loop for entity-instance-defn in ',entities
		       collect (apply #'make-entity
				      (prepare-entity-instance-args 
				       entity-instance-defn current-library))))
	  (data-files (loop for file-name in ',data-file-list
			 collect (merge-pathnames file-name 
						  (make-pathname :defaults *data-files-path*
								 :type *data-file-type*)))))
     ;; modify generic library:
     ;; (a) remove processes - and from constraint defs, too.
     ;; (b) modify constraints
     ;; (c) modify process variable and/or constraint bounds or initial values
     (setf (instance-library ',name)
	   (make-instance-library
	    :name ',name
	    :version nil
	    :generic-library current-library
	    :data-files data-files
	    :entities entities))))