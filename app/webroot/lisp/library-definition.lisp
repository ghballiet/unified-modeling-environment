(in-package :scipm)

#+SBCL
(defun structure-slots (name) 
  (loop for slot
     in (sb-mop:class-direct-slots (find-class name))
     collect (sb-mop:slot-definition-name slot)))

(defvar *print-indent-level* 0)
(defvar *print-indent-multiplier* 2)

(defmacro format* (stream control-string &rest args)
  `(format ,stream  (format NIL "~A~A"
			    (format NIL "~~~A@A" (* *print-indent-level*
						    *print-indent-multiplier*))
			    ,control-string) "" ,@args))

(defmacro with-indent (&rest forms)
  `(let ((*print-indent-level* (1+ *print-indent-level*)))
     ,@forms))

(defmacro library-setup (name)
  (labels ((make-name (prefix name suffix)
	     (intern (cond ((and prefix suffix) (format NIL "~A~A-~A" prefix name suffix))
			   (prefix (format NIL "~A-~A" prefix name))
			   (suffix (format NIL "~A-~A" name suffix)))
		     (find-package :scipm))))
    (let* ((name (string-upcase name))
	   (global-name (make-name "CURRENT-" name "LIBRARY"))
	   (lib-hash (make-name nil name "LIBRARIES"))
	   (get-lib (make-name nil name "LIBRARY"))
	   (lib-version (make-name nil name "LIBRARY-VERSION"))
	   (lib-vers-for-rerun (make-name "*" name "LIBRARY-VERSION*"))
	   (lib-path (make-name "*" name "LIBRARY-PATH*"))
	   (file-type (make-name "*" name "FILE-TYPE*"))
	   (set-lib (make-name "SET-" name "LIBRARY"))
	   (reset-lib (make-name "RESET-" name "LIBRARIES"))
	   (vrsnd-lib-pathname (make-name "VERSIONED-" name "LIBRARY-PATHNAME"))
	   (vrsnd-lib-name (make-name "VERSIONED-" name "LIBRARY-NAME")))
      `(let ((,lib-hash (make-hash-table)))
	 (defun ,vrsnd-lib-name (library-name version)
	   (format NIL "~:[~A~;~A_v_~A~]" version (string-upcase library-name) version))
	 (defun ,vrsnd-lib-pathname (versioned-lib-name)
	   (merge-pathnames versioned-lib-name
			    (make-pathname :defaults ,lib-path
					   :type ,file-type)))
	 ;; some logic notes
	 ;; when "getting" library
	 ;;   - if library is already present & no version spec'd just use it
	 ;;   - if lib present and is same version just use it
	 ;;   - if lib present but diff version: if mod'd, ask about saving mods
	 ;;   - if force-p then just reload it - blow away mods
	 (defun ,get-lib (library-name &optional version force-p)
	   (let* ((version (or version ,lib-vers-for-rerun)) ; lib-vers-... only rerun sets
		  (library-name (string-upcase library-name))
		  (versioned-lib-name (,vrsnd-lib-name library-name version))
		  (library (gethash (intern library-name (find-package :scipm)) ,lib-hash))
		  (,global-name
		   (if (and library
			    (not force-p)
			    (string-equal (,lib-version library) version))
		       library
		       (when (load (,vrsnd-lib-pathname versioned-lib-name))
			 (gethash (intern library-name (find-package :scipm)) ,lib-hash)))))
	     (setf (,lib-version ,global-name) version)
	     ,global-name))
	 (defun ,set-lib (library-name library)
	   (setf (gethash library-name ,lib-hash) library))
	 (defsetf ,get-lib ,set-lib)
	 (defun ,reset-lib () (setf ,lib-hash (make-hash-table)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun values-to-double-float (defn &rest keys)
  (loop for (k v)
     on defn
     by #'cddr
     append (list k (if (member k keys)
		      (read-from-string (format NIL "~Fd0" v))
		      v))))

(defun prepare-variable-args (variable-defn)
  ;; variable-defn :: (:name string-val
  ;;     	       :upper-bound float-val
  ;;		       :lower-bound float-val
  ;;		       :units string-val
  ;;		       :aggregators ( aggregator-type* )
  ;;		       :comment string-val )
  ;; aggregator-type :: sum | prod | min | max
  (values-to-double-float variable-defn :upper-bound :lower-bound))

(defun make-variables (variable-list)
  (loop for variable-defn
     in variable-list
     collect (apply #'make-variable-type (prepare-variable-args variable-defn))))

(defun prepare-constant-args (constant-defn)
  ;; constant-defn :: (:name string-val
  ;;		       :upper-bound float-val
  ;;		       :lower-bound float-val
  ;;		       :units string-val
  ;;		       :comment string-val )
  (values-to-double-float constant-defn :upper-bound :lower-bound))

(defun make-constants (constant-list)
  (loop for constant-defn
     in constant-list
     collect (apply #'make-constant-type (prepare-constant-args constant-defn))))

(defun prepare-entity-args (entity-defn)
  ;; entity-defn :: (:type type-string
  ;;                 :variables (variable-defn+)
  ;;                 :constants (constant-defn+)
  ;;                 :comment string-val)
  (loop for (key value)
     on entity-defn
     by #'cddr
     append (list key (case key
			(:variables (make-variables value))
			(:constants (make-constants value))
			((:type :comment) value)))))

(defun make-entities (entity-list)
  (loop for entity-defn
     in entity-list
     collect (apply #'create-generic-entity (prepare-entity-args entity-defn))))

(defun find-entity (type-string entities)
  (find type-string entities :key #'generic-entity-type :test #'string-equal))

(defun make-equations (equations-list)
  ;; differential-equation-defn :: (ODE 
  ;;                                :variable variable-type
  ;;                                :respect-to variable-type
  ;;                                :order integer-val
  ;;                                :rhs eq-right-hand-side )
  ;; algebraic-equation-defn :: (ALG
  ;;                             :variable variable-type
  ;;                             :rhs eq-right-hand-side )
  ;; variable-type :: string-val         <= one that is bound to a :name field of a variable
  ;; eq-right-hand-side :: quoted list w/arithmetic operators & operands from the process and associated entities
  (loop for eq-defn 
     in equations-list
     collect (case (first eq-defn)
	       (ODE (apply #'make-differential-equation (rest eq-defn)))
	       (ALG (apply #'make-algebraic-equation (rest eq-defn))))))

(defun prepare-entity-role-args (entity-role-defn entities)
  ;; entity-role-defn :: (:name string-val
  ;;                      :types string-val-list)   <= symbol whose value is an entity
  (loop for (key value)
     on entity-role-defn
     by #'cddr
     append (list key (case key
			(:types (loop for type-string 
				  in value
				  collect (find-entity type-string entities)))
			(:name value)))))

(defun make-entity-roles (entity-role-list entities)
  (loop for entity-role-defn
       in entity-role-list
       collect (apply #'make-entity-role (prepare-entity-role-args entity-role-defn entities))))

(defun prepare-process-args (process-defn entities)
  ;; process-defn :: (:name string-val
  ;;                  :conditions (condition-defn+)
  ;;                  :constants (constant-defn+)
  ;;  =>    :variables (variable-defn+)     <=  NO VARIABLES IN PROCESSES - conv w/Will 18May11
  ;;                  :equations ( [differential-equation-defn | algebraic-equation-defn]* )
  ;;                  :entity-roles (entity-role-defn+) 
  ;;                  :comment string-val)
  ;; condition-defn :: sexpression with boolean operator and operands from within process
  ;;                   - or lisp constants (e.g. number or string)
  (loop for (key value) on process-defn by #'cddr
     append (list key (case key
			(:constants (make-constants value))
			(:equations (make-equations value))
			(:entity-roles (make-entity-roles value entities))
			((:name :comment :conditions) value)))))

(defun make-processes (process-list entities)
     (loop for process-defn in process-list
	  collect (apply #'create-generic-process (prepare-process-args process-defn entities))))

(defun find-process (name-string processes)
  (find name-string processes :key #'gp-name :test #'string-equal))

(defun prepare-modifier (modifier-defn)
  ;; modifier-defn :: (:id symbol
  ;;                   :entity-role-name string)
  (let (id name)
    (loop for (key value) on modifier-defn by #'cddr
       do (case key
	    (:id (setf id value))
	    (:entity-role-name (setf name value))))
    (cons id name)))
	      
(defun prepare-modifier-list (modifier-list)
  ;; modifier-list :: (modifier-defn+)
  (loop for modifier-defn in modifier-list
       collect (prepare-modifier modifier-defn)))

(defun prepare-conmod-args (constraint-modifier processes)
  ;; constraint-modifier :: (:gprocess string
  ;;                         :modifiers modifier-list)
  (loop for (key value) on constraint-modifier by #'cddr
       append (case key
		(:gprocess (list :gp (find-process value processes)))
		(:modifiers (list :mods (prepare-modifier-list value))))))

(defun prepare-constraint-args (constraint-defn processes)
  ;; constraint-defn :: (:name symbol
  ;;                     :items constraint-modifier-list
  ;;                     :type constraint-type)
  ;; constraint-type :: [ exactly-one | at-most-one | always-together | necessary ]
  (loop for (key value) on constraint-defn by #'cddr
     append (list key (case key
			(:name value)
			(:type value)
			(:items (loop for constraint-modifier in value
				     collect (apply #'create-conmod
						    (prepare-conmod-args constraint-modifier processes))))))))

(defun make-constraints (constraint-list processes)
     (loop for constraint-defn
	in constraint-list 
	collect (apply #'make-constraint (prepare-constraint-args constraint-defn processes))))
	 
;; defined in global
;; (defvar *current-library* ())

#+ASDF-MISSING-DEF
(defun probe-file* (p)
  "when given a pathname P, probes the filesystem for a file or directory
with given pathname and if it exists return its truename."
  (and (pathnamep p) (not (wild-pathname-p p))
       #+clisp (ext:probe-pathname p)
       #-clisp (probe-file p)))

(defun try-directory-subpath (x sub &key type)
  (let* ((p (and x (asdf:ensure-directory-pathname x)))
         (tp (and p (asdf::probe-file* p)))
         (sp (and tp (asdf:merge-pathnames* (asdf:coerce-pathname sub :type type) p)))
         (ts (and sp (asdf::probe-file* sp))))
    (and ts (values sp ts))))

(defparameter *generic-library-directory-name* "generic-libraries")
(defparameter *generic-file-type* "glib")
(defparameter *generic-library-path* 
  (loop for dir in (asdf:split-string (getenv "XDG_DATA_DIRS") :separator ":") 
     for sub-dir = (try-directory-subpath dir *generic-library-directory-name*
						:type :directory)
     when sub-dir
     return sub-dir))


(library-setup generic)

(defmacro create-generic-library (name-symbol &key entity-list process-list constraint-list)
  ;; entity-list :: (entity-defn+)
  ;; process-list :: (process-defn+)
  ;; constraint-list :: (constraint-defn*)
  `(let* ((entities (make-entities ',entity-list))
	  (processes (make-processes ',process-list entities))
	  (constraints (make-constraints ',constraint-list processes)))
     (setf (generic-library ',name-symbol)
	   (make-library
	    :name (string ',name-symbol)
	    :processes processes
	    :entities entities
	    :constraints constraints))))

(defun find-generic-entity (entity-type-string library)
  (find-entity entity-type-string (lib-entities library)))


(defun process-constrained-by-p (process-name constraint)
  (labels ((item-gprocess-name (item)
	     (gp-name (conmod-gprocess item))))
    (find process-name (constraint-items constraint) 
	  :test #'string-equal
	  :key #'item-gprocess-name)))

(defun remove-process-from-library (process-name
				    &optional library
				    (remove-constraint-p T))
  (labels ((named-process-p (process)
	     ;; NB: if true, assume process will be removed, hence library modified
	     (let ((found (string-equal (gp-name process) process-name)))
	       (when found 
		 (setf (lib-modified library) found))))
	   (item-gprocess-name-p (item)
	     (string-equal (gp-name (conmod-gprocess item)) process-name))
	   (no-item-constraint-p (constraint)
	     (= (length (constraint-items constraint)) 0)))
    (setf (lib-processes library)
	  (remove-if #'named-process-p (lib-processes library)))
    ;; remove associate constraint-modification from constraint(s)
    (when remove-constraint-p
      (loop for constraint in (lib-constraints library)
	 when (process-constrained-by-p process-name constraint)
	 do (setf (constraint-items constraint)
		  (remove-if #'item-gprocess-name-p (constraint-items constraint))))
      (setf (lib-constraints library)
	    (remove-if #'no-item-constraint-p (lib-constraints library))))))

(defun process-constraints (generic-process library)
  (loop for constraint in (lib-constraints library)
     when (process-constrained-by-p (gp-name generic-process) constraint)
     collect constraint))

(defun processes-binding-entity (generic-entity library)
  (loop for process 
     in (lib-processes library)
     when (loop for (ignore . e-role)
	     in (gp-entity-roles process)
	     when (member generic-entity (entity-role-types e-role) :test #'eq)
	     return T)
     collect process))

(defun remove-constraint-from-library (constraint-name
				    &optional library)
  (labels ((named-constraint-p (constraint)
	     ;; NB: if true, assume constraint will be removed, hence library modified
	     (let ((found (string-equal (string (constraint-name constraint))
					constraint-name)))
	       (when found 
		 (setf (lib-modified library) found)))))
    (setf (lib-constraints library)
	  (remove-if #'named-constraint-p (lib-constraints library)))))

;;;;;; WRITING OUT A LIBRARY ;;;;;;

(defmethod save-to-generic-db (obj stream)
  (format stream "~S" obj))

(defmethod save-to-generic-db ((obj hash-table) stream)
  (let ((key-val (hash-table-values-keys obj)))
    (format stream "(~%")
    (loop for (k v) 
       on (but-last (but-last key-val))
       by #'cddr 
       do ;(format stream "(:~A~%)" k)
	 (with-indent (save-to-generic-db v stream))
	 (format stream "~%"))
;    (format stream "(:~A~%)" (car (last (but-last key-val))))
    (with-indent (save-to-generic-db (car (last key-val)) stream))
    (format stream ")")
))

(defmethod save-to-generic-db ((obj variable-type) stream)
  (let ((slot-value-list (loop for slot
			    in (structure-slots 'variable-type)
			    for value = (slot-value obj slot)
			    when value
			    collect (list slot value))))
    (when slot-value-list
      (format* stream "")
      (format stream "(")
      (let ((s-v (pop slot-value-list)))
	(format stream ":~A " (first s-v))
	(save-to-generic-db (second s-v) stream))
      (loop for s-v in slot-value-list
	 do (format stream "~%")
	 (format* stream " :~A " (first s-v))
	 (save-to-generic-db (second s-v) stream))
      (format stream ")"))))

(defmethod save-to-generic-db ((obj constant-type) stream)
  (let ((slot-value-list (loop for slot
			    in (structure-slots 'constant-type)
			    for value = (slot-value obj slot)
			    when value
			    collect (list slot value))))
    (when slot-value-list
      (format* stream "")
      (format stream "(")
      (let ((s-v (pop slot-value-list)))
	(format stream ":~A " (first s-v))
	(save-to-generic-db (second s-v) stream))
      (loop for s-v in slot-value-list
	 do (format stream "~%")
	 (format* stream " :~A " (first s-v))
	 (save-to-generic-db (second s-v) stream))
      (format stream ")"))))

(defmethod save-to-generic-db ((obj constraint-modifier) stream)
  (format stream "(:GPROCESS ~S" (gp-name (conmod-gprocess obj)))
  (let ((mods (conmod-modifiers obj)))
    (when mods
      (format stream "~%")
      (format* stream ":MODIFIERS (")
      (loop for dotted-pair
	 in mods
	 do (format stream "(:id ~S :entity-role-name ~S) "
		    (car dotted-pair) (cdr dotted-pair)))
      (format stream ")")))
  (format stream ")"))

(defmethod save-to-generic-db ((obj entity-role) stream)
  ;; can't use MOP as don't want to use save-to-generic-db method
  ;; to print out generic-entity's which are the "type" values.
  (format stream "(:NAME ~S~%" (entity-role-name obj))
  (let ((entity-role-names (loop for entity 
			      in (entity-role-types obj)
			      collect (generic-entity-type entity))))
    (format* stream ":TYPES (~{~S ~}" (but-last entity-role-names))
    (format stream "~S))" (first (last entity-role-names)))))

(defmethod save-to-generic-db ((obj differential-equation) stream)
    (let ((slot-value-list (loop for slot
			    in (structure-slots 'differential-equation)
			    for value = (slot-value obj slot)
			    when value
			    collect (list slot value))))
    (when slot-value-list
      (format stream "(ODE~%")
      (let ((s-v (pop slot-value-list)))
	(format* stream ":~A " (first s-v))
	(save-to-generic-db (second s-v) stream))
      (loop for s-v in slot-value-list
	 do (format stream "~%")
	 (format* stream ":~A " (first s-v))
	 (save-to-generic-db (second s-v) stream))
      (format stream ")"))))

(defmethod save-to-generic-db ((obj algebraic-equation) stream)
  (let ((slot-value-list (loop for slot
			    in (structure-slots 'algebraic-equation)
			    for value = (slot-value obj slot)
			    when value
			    collect (list slot value))))
    (when slot-value-list
      (format stream "(ALG~%")
      (let ((s-v (pop slot-value-list)))
	(format* stream ":~A " (first s-v))
	(save-to-generic-db (second s-v) stream))
      (loop for s-v in slot-value-list
	 do (format stream "~%")
	 (format* stream ":~A " (first s-v))
	 (save-to-generic-db (second s-v) stream))
      (format stream ")"))))

(defmethod save-to-generic-db ((obj constraint) stream)
  (let ((slot-value-list (loop for slot
			    in (structure-slots 'constraint)
			    for value = (slot-value obj slot)
			    when value
			    collect (list slot value))))
    (when slot-value-list
      (format stream "(")
      (let ((s-v (pop slot-value-list)))
	(format stream ":~A " (first s-v))
	(save-to-generic-db (second s-v) stream))
      (loop for s-v in slot-value-list
	 do (format stream "~%")
	 (format* stream ":~A " (first s-v))
	 (save-to-generic-db (second s-v) stream))
      (format stream ")~%"))))

(defmethod save-to-generic-db ((obj generic-process) stream)
  (let ((slot-value-list (loop for slot
			    in (structure-slots 'generic-process)
			    for value = (slot-value obj slot)
			    when value
			    collect (list slot value))))
    (when slot-value-list
      (format stream "(")
      (let ((s-v (pop slot-value-list)))
	(format stream ":~A " (first s-v))
	(save-to-generic-db (second s-v) stream))
      (loop for s-v in slot-value-list
	 do (format stream "~%")
	 (format* stream ":~A " (first s-v))
	 (save-to-generic-db (second s-v) stream))
      (format stream ")~%"))))

(defmethod save-to-generic-db ((obj generic-entity) stream)
  (let ((slot-value-list (loop for slot
			    in (structure-slots 'generic-entity)
			    for value = (slot-value obj slot)
			    when value
			    collect (list slot value))))
    (when slot-value-list
      (format stream "(")
      (let ((s-v (pop slot-value-list)))
	(format stream ":~A " (first s-v))
	(save-to-generic-db (second s-v) stream))
      (loop for s-v in slot-value-list
	 do (format stream "~%")
	 (format* stream ":~A " (first s-v))
	 (save-to-generic-db (second s-v) stream))
      (format stream ")~%"))))

(defmethod save-to-generic-db ((obj list) stream)
  (cond ((and (dotted-pair-p obj) (entity-role-p (cdr obj)))
	 (save-to-generic-db (cdr obj) stream))
	((dotted-pair-p obj)
	 ;; probably shouldn't get here
	 (format stream "(~A . ~A)~%" (car obj) (cdr obj)))
	((symbolp (first obj))
	 (format stream "~S" obj))
	(T
	 (with-indent 
	 (format stream "~%")
	 (format* stream "(")
	 (with-indent
	     (loop for object
		in (but-last obj)
		do (save-to-generic-db object stream)
		(format stream "~%")
		(format* stream ""))
	   (save-to-generic-db (first (last obj)) stream))
	 (format stream ")")))))

(defmethod save-to-generic-db ((obj library) stream)
  (format* stream "(in-package :scipm)~%~%~
                   (create-generic-library ~A~%" (lib-name obj))
  (with-indent
    (format* stream ":entity-list")
    (with-indent
      (save-to-generic-db (lib-entities obj) stream))
    (format stream "~%")
    (format* stream ":process-list")
    (with-indent
      (save-to-generic-db (lib-processes obj) stream))
    (format stream "~%")
    (format* stream ":constraint-list")
    (with-indent ()
      (save-to-generic-db (lib-constraints obj) stream)))
  (format stream ")"))


(defun save-generic-library (library &optional (version (get-universal-time)))
  (let ((generic-library-path (versioned-generic-library-pathname
			       (versioned-generic-library-name (lib-name library) version))))
    (with-open-file (stream generic-library-path
			    :direction :output
			    :if-does-not-exist :create)
      (save-to-generic-db library stream))))

;;;;;

(defun print-gp-summary (p &optional (stream t))
  (format stream "~A{~A}~%" 
	  (gp-name p) 
	  (mapcar #'cdr (gp-entity-roles p))))

(defun print-constraint-summary (c &optional (stream t))
  (format* stream "~A, type=~A~%"
	   (constraint-name c)
	   (constraint-type c))
  (with-indent 
      (format* stream "Items:~%")
    (loop for item in (constraint-items c)
       do (with-indent
	      (format* stream "(GProcess: ~A" (gp-name (conmod-gprocess item)))
	    (let ((mods (conmod-modifiers item)))
	      (when mods
		(format stream "  ")	;"~%")
		(format stream " Modifiers: ~S" mods))
	      (format stream ")~%"))))))

(defun display-generic-library (library &optional (stream t))
	 (let ((entities (lib-entities library))
	       (processes (lib-processes library))
	       (constraints (lib-constraints library)))
	   (format stream "~A~%" (lib-name library))
	   (with-indent 
	       (format* stream "Entities:~%")
	     (with-indent
		 (loop for e 
		    in entities
		    do (format* stream "")
		      (print-ge e stream) 
		      (format stream "~%"))))
	   (with-indent 
	       (format* stream "Processes:~%")
	     (with-indent
		 (loop for p
		    in processes
		    do (format* stream "")
		      (print-gp-summary p stream))))
	   (with-indent 
	       (format* stream "Constraints:~%")
	     (with-indent
		 (loop for c
		    in constraints
		    do (print-constraint-summary c stream)
		    (format stream "~%"))))))