(in-package :scipm)

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; APPLICATION FRAME ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(define-application-frame scipm-frame ()
  ((current-component :initform nil :accessor scipm-frame-current-component)
   (current-run-parameter :initform nil :accessor scipm-frame-current-run-parameter)
   (nmodels :initform 1 :accessor scipm-frame-nmodels)
   (current-instance-library :initform nil :accessor scipm-frame-current-instance-library)
   (current-result-model :initform nil :accessor scipm-frame-current-result-model)
   (current-result-params :initform nil :accessor scipm-frame-current-result-params)
   (edit-mode :initform nil :accessor scipm-frame-edit-mode))
  (:panes
;;; Edit
   (library-list
    (make-pane 'scipm-option-pane		;'list-pane
	       :default-prompt "Select a Generic Library"
	       :value nil
	       :items (generic-libraries-list)
	       :associated-display-pane 'library-view
					;	       :presentation-type-key (constantly 'generic-library-symbol)
	       :name-key (lambda (x) (format nil "~(~S~)" x))
	       :display-time :command-loop))
   (library-interactor :application
		       :incremental-redisplay T)
   (library-view :application
					;	 :incremental-redisplay T
		 :end-of-page-action :allow
		 :text-style (make-text-style :sans-serif :roman :normal)
		 :scroll-bars T
		 :width 450
		 :height 800 
		 :display-function 'display-library-summary
		 :display-time :command-loop)
   (component-view :application
		   :incremental-redisplay T
		   :text-style (make-text-style :sans-serif :roman :normal)
		   :scroll-bars T
		   :width 500
		   :height 800 
		   :display-function 'display-component-detail
		   :display-time :command-loop)
   (library-save (make-pane 'push-button
			    :label "Save Current Library"
			    :client 'library-view
			    :id 'save-library
			    :activate-callback 'save-current-library))
   (process-add (make-pane 'push-button
			   :label "Add a New Process"
			   :client 'library-view
			   :id 'process-add
			   :activate-callback 'simple-accept-new-process))
   (constraint-add (make-pane 'push-button
			      :label "Add a New Constraint"
			      :client 'library-view
			      :id 'constraint-add
			      :activate-callback 'simple-accept-new-constraint))
;;; Run 
   (run-par-list
    (make-pane 'scipm-option-pane
	       :default-prompt "Select Initial Parameter Set"
	       :associated-display-pane 'run-sim
	       :value nil
	       :items (instance-libraries-list)
					;	       :presentation-type-key (constantly 'instance-library-symbol)
	       :name-key (lambda (x) (format nil "~(~S~)" x))))
   (run-sim :application
	    :incremental-redisplay T
	    :end-of-page-action :allow
	    :text-style (make-text-style :sans-serif :roman :normal)
	    :scroll-bars T
	    :width 450
	    :display-function 'display-instance-library-summary
	    :display-time :command-loop)
   (run-sim-details :application
		    :incremental-redisplay T
		    :end-of-page-action :allow
		    :text-style (make-text-style :sans-serif :roman :normal)
		    :scroll-bars T
		    :width 500
		    :height 800 
		    :display-function 'display-sim-parameter-detail
		    :display-time :command-loop)
   (run-sim-status :application)
   (run-sim-button (make-pane 'push-button
			      :label "Start SCIPM Model Search"
			      :client 'run-sim-status
			      :id 'start
			      :activate-callback 'get-sim-params-and-run))
;;; results
   (result-examiner :application
		    :incremental-redisplay T
		    :end-of-page-action :allow
		    :text-style (make-text-style :sans-serif :roman :normal)
		    :scroll-bars T
		    :height 800 
		    :display-function 'display-results-summary
		    :display-time :command-loop)
   (result-details  :application
		    :incremental-redisplay T
		    :end-of-page-action :allow
		    :text-style (make-text-style :sans-serif :roman :normal)
		    :scroll-bars T
		    :height 800 
		    :display-function 'display-results-details
		    :display-time :command-loop)
   (results-save (make-pane 'push-button
			    :label "Save Results"
			    :client 'result-examiner
			    :id 'save
			    :activate-callback
			    #'(lambda (g) 
				(declare (ignore g))
				(let ((pane (sane-find-pane-named
					     *application-frame* 'results-status)))
				  (window-clear pane)
				  (if (keyword-value :saved-p *results*)
				      (format pane "Results saved already")
				      (progn (save-results)
					     (format pane "Results saved")))))))
   (results-status :application)			    
   (results-plot (make-pane 'push-button
			    :label "Show Model Plot"
			    :client 'result-examiner
			    :id 'plot
			    :activate-callback
			    #'(lambda (g) 
				(declare (ignore g))
				(let ((pane (sane-find-pane-named
					     *application-frame* 'results-status)))
				  (window-clear pane)
				  (if (keyword-value :saved-p *results*)
				      (if (scipm-frame-current-result-model
					   *application-frame*)
					  (plot-model-simulation 
					   (string (model-name 
						    (scipm-frame-current-result-model
						     *application-frame*)))
					   (results-directory-pathname *results*))
					  (format pane "Please select a Model~%~
                                                   from pane to the right"))
				      (format pane "Need to save results~%~
                                                    before plotting"))))))
   (results-eqs (make-pane 'push-button
			   :label "Show Model Equations (PDF)"
			   :client 'result-examiner
			   :id 'eqs
			   :activate-callback
			   #'(lambda (g)
			       (declare (ignore g))
			       (let ((pane (sane-find-pane-named
					    *application-frame* 'results-status)))
				 (window-clear pane)
				 (if (keyword-value :saved-p *results*)
				     (if (scipm-frame-current-result-model
					  *application-frame*)
					 (show-model-equations  
					  (string (model-name 
						   (scipm-frame-current-result-model
						    *application-frame*)))
					  (results-directory-pathname *results*))
					 (format pane "Please select a Model~%~
                                                   from pane to the right"))
				     (format pane "Need to save results~%~
                                                   before typesetting~%~
                                                   equations"))))))
   (pointer-doc :pointer-documentation))
  (:layouts
   (defaults
       (vertically ()
	 (labelling (:label "SCIPM Interactor"
			    :text-style (make-text-style :sans-serif :roman :normal)))
	 (with-tab-layout ('tab-page :name 'scipm-layout :height 800 
				     :display-time :command-loop)
	   ("Generic Library Inspector" 
	    (vertically ()
	      (horizontally ()
		library-list		
		library-save
		process-add
		constraint-add)
	      (horizontally ()
		(vertically ()
		  library-view
		  library-interactor)
		component-view)))
	   ("Run Model Search" 
	    (vertically ()
	      (horizontally ()
		run-par-list
		run-sim-button)
	      (horizontally ()
		(vertically ()
		  (0.6 run-sim)
		  run-sim-status)
		run-sim-details)))
	   ("Examine Results"
	    (vertically ()
	      (horizontally () 
		results-save
		results-plot
		results-eqs)
	      (horizontally ()
		(vertically ()
		  (.1 results-status)
		  result-examiner)
		(.5 result-details)))))
	 pointer-doc))))

;;;; GENERIC DECLARATIONS

(defgeneric get-library-from-filename (frame))
(defgeneric accept-constraint-type (old-value))
(defgeneric accept-existing-generic-entities (old-value))
(defgeneric accept-new-constant (component frame))
(defgeneric accept-new-constraint-item (component frame))
(defgeneric accept-new-entity-role (component frame))
(defgeneric accept-new-equation (component frame))
(defgeneric accept-simple-double-float (old-value))
(defgeneric accept-simple-sexpr (old-value))
(defgeneric accept-simple-string-value (old-value))
(defgeneric delete-constant (component frame))
(defgeneric delete-constraint-item (component frame))
(defgeneric delete-entity-role (component frame))
(defgeneric delete-equation (component frame))
(defgeneric display-library-summary (frame stream))

;;;; MACROS

(defmacro construct-accept-lib-component-simple-type 
    (accessor-fn-name presentation-type simple-type)
  (let ((trans-name (intern (string-upcase (format nil "accept-~A" accessor-fn-name))))
	(com-name (intern (string-upcase (format nil "com-edit-~A" accessor-fn-name)))))
    `(progn
       (define-presentation-to-command-translator ,trans-name
	   (,presentation-type ,com-name scipm-frame
			       :gesture :select 
			       :tester ((frame) (scipm-frame-edit-mode frame)))
	   (object)
	 (list object))

       (define-scipm-frame-command ,com-name
	   ((object ',presentation-type))
	 (setf (,accessor-fn-name object)
	       (,(case simple-type
		       (string 'accept-simple-string-value)
		       (float 'accept-simple-double-float)
		       (sexpr 'accept-simple-sexpr)
		       (ge-set 'accept-existing-generic-entities)
		       (constraint-type 'accept-constraint-type))
		 (,accessor-fn-name object)))))))

(defmacro define-editable-presentation-type (ptype access-fn-name simple-type)
  `(progn
     (define-presentation-type ,ptype ())
     (construct-accept-lib-component-simple-type ,access-fn-name ,ptype ,simple-type)))

(defmacro gen-copy-and-insert-component (component-type)
  (multiple-value-bind (create-func prepare-func name-func extra-args-func lib-access-func)
      (case component-type
	(generic-entity 
	 (values 'create-generic-entity 'prepare-entity-args 'generic-entity-type
		 nil 'lib-entities))
	(generic-process 
	 (values 'create-generic-process 'prepare-process-args 
		 'gp-name 'lib-entities 'lib-processes))
	(constraint
	 (values 'make-constraint 'prepare-constraint-args
		 'constraint-name 'lib-processes 'lib-constraints)))
    `(defmethod copy-and-insert-component ((component ,component-type) frame)
       (let* ((component-raw-copy
	       (read-from-string
		(with-output-to-string (ostr)
		  (save-to-generic-db component ostr))))
	      (glib (get-library-from-filename frame))
	      (component-copy
	       (apply #',create-func
		      ,(read-from-string 
			(format nil "(~A component-raw-copy ~{(~A glib)~})"
				prepare-func (if extra-args-func (list extra-args-func) nil))))))
	 (setf (,name-func component-copy)
	       (format nil "~A-COPY" (,name-func component-copy)))
	 (setf (,lib-access-func glib) 
	       (append (,lib-access-func glib) (list component-copy)))
	 (setf (scipm-frame-current-component frame) component-copy)))))

(defmacro create-scipm-component-action-button (action-label action-name mode action-fn-name)
  (let* ((action-button 
	  (intern (string-upcase (format nil "~A-button" action-name))))
	 (display-action-button
	  (intern (string-upcase (format nil "display-~A-button" action-name))))
	 (act-on-component
	  (intern (string-upcase (format nil "~A-component" action-name))))
	 (com-action-component
	  (intern (string-upcase (format nil "com-~A-component" action-name)))))
    `(progn
       (define-presentation-type ,action-button () :inherit-from t)

       (defun ,display-action-button (stream)
	 (display-button ,action-label ',action-button stream))

       (define-presentation-to-command-translator ,act-on-component
	   (,action-button ,com-action-component scipm-frame
			   :tester ((frame) ,(if (equal mode 'edit)
						 '(scipm-frame-edit-mode frame)
						 '(not (scipm-frame-edit-mode frame)))))

	   (frame)
	 (list (scipm-frame-current-component frame)))

       (define-scipm-frame-command ,com-action-component
	   ((component '(or generic-entity-presentation
			 generic-process-presentation
			 constraint-presentation)))
	 (,action-fn-name component *application-frame*)))))

(defun scipm-frame (&optional (new-process nil))
  (if new-process
      (clim-sys:make-process #'(lambda () (run-frame-top-level (make-application-frame 'scipm-frame)))
			     :name "Scipm Frame")
      (run-frame-top-level (make-application-frame 'scipm-frame))))

(defun current-scipm-tab-title? (title-string &optional (frame *application-frame*))
  (string-equal title-string  (tab-page-title
			       (tab-layout-enabled-page
				(sane-find-pane-named frame 'scipm-layout)))))

(defun expose-scipm-tab (name-string)
  (unless (current-scipm-tab-title? name-string)
    (com-switch-to-tab-page 
     (find-tab-page-named name-string 
			  (sane-find-pane-named *application-frame* 'scipm-layout)))))

(defun make-lib-context-match-run-context ()
      (setf (gadget-value (sane-find-pane-named *application-frame* 'library-list))
	    (lib-list-filename-from-glib
	     (instance-library-generic-library (scipm-frame-current-instance-library
						*application-frame*)))))

(defun make-run-context-match-result-context ()
  (let ((instance-library-name (keyword-value :instance-library-name *results*)))
    (setf (scipm-frame-current-instance-library *application-frame*)
	  (instance-library instance-library-name)
	  (gadget-value (sane-find-pane-named *application-frame* 'run-par-list))
	  instance-library-name)))

(defun make-scipm-tab-contexts-match ()
  (cond ((current-scipm-tab-title? "Run Model Search")
	 (make-lib-context-match-run-context))
	((current-scipm-tab-title? "Examine Results")
	 (make-run-context-match-result-context)
	 (make-lib-context-match-run-context))))

(defmethod get-library-from-filename ((frame scipm-frame))
  (let* ((lib-list-pane (sane-find-pane-named frame 'library-list))
	 (lib-list-value (gadget-value lib-list-pane))
	 (lib-name-version (let* ((lib-name (string lib-list-value))
				  (v? (search "_v_" lib-name :test #'string-equal)))
			     (if v?
				 (list (subseq lib-name 0 v?)
				       (subseq lib-name (+ 3 v?)))
				 (list lib-name nil)))))
    (when lib-list-value
	  (generic-library (first lib-name-version)
			   (second lib-name-version)))))

(defun gp-named (process-name frame)
  ;; find generic process with process name for current library of frame
  (find process-name
	(lib-processes 
	 (get-library-from-filename frame))
	:key #'gp-name
	:test #'string-equal))

(defgeneric present-scipm-object (object frame stream))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; library component detail ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod display-component-detail ((frame scipm-frame) stream)
  (let ((object (scipm-frame-current-component frame)))
    (when object
      (fresh-line stream)
      (formatting-table (stream :multiple-columns 1 :x-spacing '(2 :character))
	(formatting-row (stream)
	  (formatting-cell (stream :align-x :center)
	    (display-copy-button stream))
      	  (formatting-cell (stream :align-x :center)
	    (if (scipm-frame-edit-mode frame)
		(display-inspect-button stream)
		(display-edit-button stream)))
	  (formatting-cell (stream :align-x :center)
	    (display-delete-button stream))))
      (fresh-line stream)
      (present-scipm-object object frame stream)))
  (format stream "~%"))

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; constraint detail ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(define-editable-presentation-type constraint-name-presentation constraint-name string)
(define-editable-presentation-type constraint-type-presentation constraint-type constraint-type)

(eval-when (:compile-toplevel :load-toplevel)
  (define-presentation-type constraint-item-presentation ()))

(define-presentation-method present (object (type constraint-item-presentation)
					    stream (view textual-view) &key)
  ;; clim accepts a symbol, not the whole string. So we wrap the string in "|",
  ;; which means the whole string gets returned as a symbol (spaces, quotes, etc. included).
  ;; so ugly.
  (format stream "|~A" (gp-name (conmod-gprocess object)))
  (let ((mods (conmod-modifiers object)))
    (when mods
      (format stream " ~S" mods)))
  (format stream "|"))

(define-presentation-type constraint-modifier-gprocess-presentation ())
;; (define-presentation-type constraint-condition-presentation ())

(defmethod present-scipm-object ((object constraint-modifier) frame stream)
  (formatting-table (stream :multiple-columns 1)
    (formatting-row (stream)
      (formatting-cell (stream) (with-text-face (stream '(:bold :italic))
				  (format stream "Generic Process:")))
      (with-output-as-presentation (stream (conmod-gprocess object)
					   'constraint-modifier-gprocess-presentation)
	(formatting-cell (stream) 
	  (let ((p (conmod-gprocess object)))
	    (with-output-as-presentation (stream p 'generic-process-presentation)
	      (print-gp-summary p stream))))))
    (formatting-row (stream)

      (formatting-cell (stream) (with-text-face (stream '(:bold :italic))
				  (format stream "Modifiers:")))
      (let ((modifiers (conmod-modifiers object)))
	(when modifiers
	  (formatting-cell (stream) 
	    (formatting-table (stream :multiple-columns 1)
	      (loop for (id . v) 
		 in modifiers
		 do (formatting-row (stream)
		      (formatting-cell (stream) (with-text-face (stream :italic)
						  (format stream "ID:")))
		      (formatting-cell (stream)
			(with-output-as-presentation
			    (stream id 'symbol) (format stream "~A" id)))
		      (formatting-cell (stream) (with-text-face (stream :italic)
						  (format stream "Entity Role Name:")))
		      (formatting-cell (stream)
			(with-output-as-presentation 
			    (stream id 'string) (format stream "~A" v))))))))))))

(defun display-constraint-items (items frame stream)
  (formatting-table (stream :multiple-columns 1 :y-spacing '(1 :character))
    (loop for item
       in items
       do (with-output-as-presentation (stream item 'constraint-item-presentation :single-box T)
	    (formatting-row (stream) 
	      (formatting-cell (stream)
		(present-scipm-object item frame stream)))))))

(defmethod present-scipm-object ((object constraint) frame stream)
  (with-output-as-presentation (stream object 'constraint-presentation :single-box T)
    (with-text-face (stream :bold) (format stream "Constraint~%"))
    (with-text-face (stream '(:bold :italic)) (format stream "  Name:  "))
    (with-output-as-presentation (stream object 'constraint-name-presentation)
      (format stream "~A" (constraint-name object)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Type:  "))
    (with-output-as-presentation (stream object 'constraint-type-presentation)
      (format stream "~A" (constraint-type object)))
    (with-text-face (stream '(:bold :italic))
      (format stream "~%  Items:                    "))
    ;; edit mode additions for complex object addtion and deletion
    (when (scipm-frame-edit-mode frame)
      (display-add-constraint-item-button stream)
      (with-text-face (stream :italic)
	(with-text-size (stream :large)
	  (format stream " or ")))
      (display-delete-constraint-item-button stream)
      (with-text-face (stream :italic)
	(with-text-size (stream :large)
	  (format stream " Item"))))
    (format stream "~%    ")
    (let ((items (constraint-items object)))
      (when items
	(display-constraint-items items frame stream)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; generic-process detail ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-editable-presentation-type gp-name-presentation gp-name string)
(define-editable-presentation-type gp-condition-presentation gp-conditions string)
(define-editable-presentation-type gp-comment-presentation gp-comment string)

(eval-when (:compile-toplevel :load-toplevel)
  (define-presentation-type equation-presentation ()))

(define-presentation-method present (object (type equation-presentation)
					    stream (view textual-view) &key)
  (format stream "~S" (slot-value object 'variable)))

(define-editable-presentation-type diff-eq-var-presentation diff-eq-variable string)
(define-editable-presentation-type diff-eq-respect-to-presentation diff-eq-respect-to string)
(define-editable-presentation-type diff-eq-order-presentation diff-eq-order string)
(define-editable-presentation-type diff-eq-rhs-presentation diff-eq-rhs sexpr)

(define-editable-presentation-type alg-eq-var-presentation alg-eq-variable string)
(define-editable-presentation-type alg-eq-rhs-presentation alg-eq-rhs sexpr)

(defmethod present-scipm-object ((object differential-equation) frame stream)
  (formatting-cell (stream :align-x :right)
    (format stream "d[")
    (with-output-as-presentation (stream object 'diff-eq-var-presentation)
      (format stream "~A" (diff-eq-variable object)))
    (format stream ",")
    (with-output-as-presentation (stream object 'diff-eq-respect-to-presentation)
      (format stream "~A" (or (diff-eq-respect-to object) "time")))
    (format stream ",")
    (with-output-as-presentation (stream object 'diff-eq-order-presentation)
      (format stream "~A" (diff-eq-order object)))
    (format stream "]"))
  (formatting-cell (stream :align-x :center) (format stream "="))
  (formatting-cell (stream :align-x :left)
    (with-output-as-presentation (stream object 'diff-eq-rhs-presentation)
      (print-diff-eq-rhs (diff-eq-rhs object) stream ""))))

(defmethod present-scipm-object ((object algebraic-equation) frame stream)
  (formatting-cell (stream :align-x :right)
    (with-output-as-presentation (stream object 'alg-eq-var-presentation)
      (format stream "~A" (alg-eq-variable object))))
  (formatting-cell (stream :align-x :center) (format stream "="))
  (formatting-cell (stream :align-x :left)
    (with-output-as-presentation (stream object 'alg-eq-rhs-presentation)
      (format stream "~A" (alg-eq-rhs object)))))

(defun display-eqs (eqs frame stream)
  (formatting-table (stream :multiple-columns 1 :y-spacing '(1 :character))
    (loop for eq
       in eqs
       do (formatting-row (stream) 
	    (with-output-as-presentation (stream eq 'equation-presentation :single-box T)
	      (present-scipm-object eq frame stream))))))

(eval-when (:compile-toplevel :load-toplevel)
  (define-presentation-type entity-role-presentation ()))

(define-presentation-method present (object (type entity-role-presentation)
					    stream (view textual-view) &key)
  (format stream "~S" (entity-role-name object)))

(define-editable-presentation-type entity-role-name-presentation entity-role-name string)
(define-editable-presentation-type generic-entity-presentation-editable entity-role-types
  ge-set)

(defmethod present-scipm-object ((object entity-role) frame stream)
  (formatting-table (stream :multiple-columns 1)
    (formatting-row (stream)
      (formatting-cell (stream) (with-text-face (stream :italic) (format stream "Role Name:")))
      (formatting-cell (stream)
	(with-output-as-presentation 
	    (stream object 'entity-role-name-presentation)
	  (format stream "~A" (entity-role-name object)))))
    (let ((entity-role-types (or (entity-role-types object) '(:empty)))
	  (first T))
      (loop for type 
	 in entity-role-types
	 do (formatting-row (stream)
	      (formatting-cell (stream) (when first
					  (setf first NIL)
					  (with-text-face (stream :italic) 
					    (format stream "Acceptable Type~@[s~]:"
						    (rest entity-role-types)))))
	      (formatting-cell (stream)
		(with-output-as-presentation (stream object 'generic-entity-presentation-editable)
		  (if (eq type :empty)
		      (with-drawing-options (stream :ink +dark-grey+ :text-face :italic)
			(format stream "~A" type))
		      (format stream "~A" (generic-entity-type type))))))))))

(defun display-entity-roles (roles frame stream)
  (formatting-table (stream :multiple-columns 1 :y-spacing '(1 :character))
    (loop for (ignore . role)
       in roles
       do (formatting-row (stream) 
	    (formatting-cell (stream)
	      (with-output-as-presentation (stream role 'entity-role-presentation :single-box T)
		(present-scipm-object role frame stream)))))))

(defun display-process-constraints (generic-process frame stream)
  (let ((process-constraints (process-constraints generic-process 
						  (get-library-from-filename frame))))
    (if process-constraints
	(formatting-table (stream :multiple-columns 1)
	  (loop for constraint
	     in process-constraints
	     do (formatting-row (stream) 
		  (formatting-cell (stream)
		    (with-output-as-presentation (stream constraint
							 'constraint-presentation)
		      (format stream "~A" (constraint-name constraint)))))))
	(with-text-face (stream :italic) (format stream "unconstrained")))))

(defmethod accept-simple-string-value (old-value)
  (let* ((library-interactor (sane-find-pane-named *application-frame* 'library-interactor))
	 new-value)
    (window-clear library-interactor)
    (accepting-values (library-interactor :initially-select-query-identifier 'the-tag)
      (setf new-value
	    (accept 'string
		    :stream library-interactor
		    :default old-value
		    :provide-default T
		    :query-identifier 'the-tag
		    :prompt "New Value")))
    (window-clear library-interactor)
    new-value))

(defmethod accept-constraint-type (old-value)
  (let* ((stream (sane-find-pane-named *application-frame* 'library-interactor))
	 new-value)
    (window-clear stream)
    (accepting-values (stream :initially-select-query-identifier 'the-tag)
      (setf new-value
	    (accept 'string
		    :stream stream
		    :default old-value
		    :provide-default T
		    :query-identifier 'the-tag
		    :prompt "Enter one of: EXACTLY-ONE, AT-MOST-ONE,~
                             ALWAYS-TOGETHER, or NECESSARY")))
    (window-clear stream)
    (let ((return-value (intern (string-upcase new-value))))
      (if (member return-value '(exactly-one at-most-one always-together necessary))
	  return-value
	  (progn (format stream "Value entered, ~A, not one of EXACTLY-ONE, AT-MOST-ONE,~
                             ALWAYS-TOGETHER, or NECESSARY" new-value)
		 old-value)))))

(defmethod accept-simple-double-float (old-value)
  (let* ((library-interactor (sane-find-pane-named *application-frame* 'library-interactor))
	 new-value)
    (window-clear library-interactor)
    (accepting-values (library-interactor :initially-select-query-identifier 'the-tag)
      (setf new-value
	    (accept '(or rational float null)
		    :stream library-interactor
		    :default old-value
		    :provide-default T
		    :query-identifier 'the-tag
		    :prompt "New Value")))
    (window-clear library-interactor)
    (when new-value
      (read-from-string (format NIL "~Fd0" new-value)))))

(defmethod accept-simple-sexpr (old-value)
  (let* ((library-interactor (sane-find-pane-named *application-frame* 'library-interactor))
	 new-value)
    (window-clear library-interactor)
    (accepting-values (library-interactor :initially-select-query-identifier 'the-tag)
      (setf new-value
	    (accept 'expression
		    :stream library-interactor
		    :default old-value
		    :provide-default T
		    :query-identifier 'the-tag
		    :prompt "New Value")))
    (window-clear library-interactor)
    new-value))

(defmethod accept-existing-generic-entities (old-value)
  (let* ((library-interactor (sane-find-pane-named *application-frame* 'library-interactor))
	 new-value)
    (window-clear library-interactor)
    (let* ((lib-entities (lib-entities (get-library-from-filename *application-frame*)))
	   (entity-str-list (loop for entity 
			       in lib-entities
			       collect (generic-entity-type entity)))
	   (ge-set-prompt-str (format nil "Enter existing Generic Entity Type(s) from: ~A~{,~A~} - "
				      (first entity-str-list) (rest entity-str-list))))
      (accepting-values (library-interactor :initially-select-query-identifier 'the-tag)
	(setf new-value
	      (accept `string
		      :stream library-interactor
					;		      :default old-value
					;		      :provide-default T
		      :query-identifier 'the-tag
		      :prompt ge-set-prompt-str)))
      (window-clear library-interactor)
      (when new-value
	(let (new-entity-list errors)
	  (with-input-from-string (str new-value)
	    (loop for x = (read str nil :eof) 
	       if (eq x :eof) 
	       return new-entity-list
	       else do (let ((ent? (find x lib-entities
					 :test #'string-equal
					 :key #'generic-entity-type)))
			 (if ent?
			     (pushnew ent? new-entity-list :test #'equal)
			     (push x errors)))))
	  (if (null errors)
	      new-entity-list
	      (progn
	      (format library-interactor 
		      "Value(s) entered (~A~{,~A~}) not existing Generic Entity Type: ~A."
		      (first errors) (rest errors) entity-str-list)
	      old-value)))))))

(defmethod present-scipm-object ((object generic-process) frame stream)
  (with-output-as-presentation (stream object 'generic-process-presentation :single-box T)
    (with-text-face (stream :bold) (format stream "Generic Process~%"))
    (with-text-face (stream '(:bold :italic)) (format stream "  Name:  "))
    (with-output-as-presentation (stream object 'gp-name-presentation)
      (format stream "~A" (gp-name object)))
    (with-text-face (stream '(:bold :italic))
      (format stream "~%  Entity Roles:                    "))
    ;; edit mode additions for complex object addtion and deletion
    (when (scipm-frame-edit-mode frame)
      (display-add-entity-role-button stream)
      (with-text-face (stream :italic)
	(with-text-size (stream :large)
	  (format stream " or ")))
      (display-delete-entity-role-button stream)
      (with-text-face (stream :italic)
	(with-text-size (stream :large)
	  (format stream " Entity Role"))))
    (format stream "~%    ")
    (let ((e-roles (gp-entity-roles object)))
      (when e-roles
	(display-entity-roles e-roles frame stream)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Conditions:  ~%    "))
    (with-output-as-presentation (stream object 'gp-condition-presentation)
      (format stream "~A" (gp-conditions object)))
    (with-text-face (stream '(:bold :italic))
      (format stream "~%  Constants:                      "))
    ;; edit mode additions for complex object addtion and deletion
    (when (scipm-frame-edit-mode frame)
      (display-add-constant-button stream)
      (with-text-face (stream :italic)
	(with-text-size (stream :large)
	  (format stream " or ")))
      (display-delete-constant-button stream)
      (with-text-face (stream :italic)
	(with-text-size (stream :large)
	  (format stream " Constant"))))
    (format stream "~%    ")
    (let ((c-hash (gp-constants object)))
      (when c-hash
	(display-v/c-hash c-hash frame stream)))
    (with-text-face (stream '(:bold :italic))
      (format stream "~%  Equations:                      "))
    ;; edit mode additions for complex object addtion and deletion
    (when (scipm-frame-edit-mode frame)
      (display-add-equation-button stream)
      (with-text-face (stream :italic)
	(with-text-size (stream :large)
	  (format stream " or ")))
      (display-delete-equation-button stream)
      (with-text-face (stream :italic)
	(with-text-size (stream :large)
	  (format stream " Equation"))))
    (format stream "~%    ")
    (let ((eqs (gp-equations object)))
      (when eqs
	(display-eqs eqs frame stream)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Comment:  "))
    (with-output-as-presentation (stream object 'gp-comment-presentation)
      (format stream "~A" (gp-comment object)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Constrained By:  "))
    (display-process-constraints object frame stream)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; generic-entity detail ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define-presentation-type generic-entity-detail-presentation ())
(define-presentation-type ge-type-presentation ())
(define-presentation-type ge-variable-presentation ())
(eval-when (:compile-toplevel :load-toplevel)
  (define-presentation-type ge-constant-presentation ()))
(define-presentation-type ge-comment-presentation ())

(define-editable-presentation-type v-type-name-presentation variable-type-name string)
(define-editable-presentation-type v-type-upper-bound-presentation variable-type-upper-bound
				      float)
(define-editable-presentation-type v-type-lower-bound-presentation variable-type-lower-bound
				      float)
(define-editable-presentation-type v-type-units-presentation variable-type-units string)
(define-editable-presentation-type v-type-aggregators-presentation variable-type-aggregators
				      string)
(define-editable-presentation-type v-type-comment-presentation variable-type-comment string)

(define-editable-presentation-type c-type-name-presentation constant-type-name string)
(define-editable-presentation-type c-type-upper-bound-presentation constant-type-upper-bound
				      float)
(define-editable-presentation-type c-type-lower-bound-presentation constant-type-lower-bound
				      float)
(define-editable-presentation-type c-type-units-presentation constant-type-units string)
(define-editable-presentation-type c-type-comment-presentation constant-type-comment string)

(define-presentation-method present (object (type ge-constant-presentation)
					    stream (view textual-view) &key)
  (format stream "~S" (constant-type-name object)))

(defmethod present-scipm-object ((object variable-type) frame stream)
  (with-output-as-presentation (stream object 'ge-variable-presentation :single-box T)
    (formatting-table (stream :multiple-columns 1 :x-spacing '(1 :character))
      (loop for (field ptype) in '((name v-type-name-presentation)
				   (upper-bound v-type-upper-bound-presentation)
				   (lower-bound v-type-lower-bound-presentation)
				   (units v-type-units-presentation)
				   (aggregators v-type-aggregators-presentation)
				   (comment v-type-comment-presentation))
	 do (formatting-row (stream)
	      (formatting-cell (stream) (format stream "~A" (string field)))
	      (with-output-as-presentation (stream object ptype)
		(formatting-cell (stream) (format stream "~A" (slot-value object field)))))))))

(defmethod present-scipm-object ((object constant-type) frame stream)
  (with-output-as-presentation (stream object 'ge-constant-presentation :single-box T)
    (formatting-table (stream :multiple-columns 1 :x-spacing '(1 :character))
      (loop for (field ptype) in '((name c-type-name-presentation)
				   (upper-bound c-type-upper-bound-presentation)
				   (lower-bound c-type-lower-bound-presentation)
				   (units c-type-units-presentation)
				   (comment c-type-comment-presentation))
	 do (formatting-row (stream)
	      (formatting-cell (stream) (format stream "~A" (string field)))
	      (with-output-as-presentation (stream object ptype)
		(formatting-cell (stream) (format stream "~A" (slot-value object field)))))))))

(defun display-v/c-hash (hash frame stream)
  (formatting-table (stream :multiple-columns 1
			    :x-spacing '(2 :character)
			    :y-spacing '(1 :character))
    (loop for (k v) on (hash-table-values-keys hash) by #'cddr
	 do (formatting-row (stream)
	      (formatting-cell (stream) (format stream "~A" k))
	      (formatting-cell (stream) (present-scipm-object v frame stream))))))

(defun display-entity-binding-processes (generic-entity frame stream)
  (let ((processes-binding-entity 
	 (processes-binding-entity generic-entity
				   (get-library-from-filename frame))))
    (if processes-binding-entity
	(formatting-table (stream :multiple-columns 1)
	  (loop for process 
	     in processes-binding-entity
	     do (formatting-row (stream)
		  (formatting-cell (stream)
		    (with-output-as-presentation (stream process
							 'generic-process-presentation)
		      (format stream "~A" (gp-name process)))))))
	(with-text-face (stream :italic) (format stream "No processes use this entity")))))

(defmethod present-scipm-object ((object generic-entity) frame stream)
  (with-output-as-presentation (stream object 'generic-entity-presentation :single-box T)
    (with-text-face (stream :bold) (format stream "Generic Entity~%"))
    (with-text-face (stream '(:bold :italic)) (format stream "  Type:  "))
    (with-output-as-presentation (stream (generic-entity-type object) 'ge-type-presentation)
      (format stream "~A" (generic-entity-type object)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Variables:  ~%    "))
    (let ((v-hash (generic-entity-variables object)))
      (when v-hash
	(display-v/c-hash v-hash frame stream)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Constants:  ~%    "))
    (let ((c-hash (generic-entity-constants object)))
      (when c-hash
	(display-v/c-hash c-hash frame stream)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Comment:  "))
    (with-output-as-presentation 
	(stream (generic-entity-comment object) 'ge-comment-presentation)
      (format stream "~{~A~}" (list (generic-entity-comment object))))
    (with-text-face (stream '(:bold :italic))
      (format stream "~%  Processes Binding to Roles:  "))
    (display-entity-binding-processes object frame stream)))

;;;;;;;;;;;;;;;;;;;;;;;
;;; library summary ;;;
;;;;;;;;;;;;;;;;;;;;;;;

(define-presentation-type generic-entity-presentation ())

(defun examine-generic-component (generic-component)
  (make-scipm-tab-contexts-match)
  (setf (scipm-frame-current-component *application-frame*) generic-component)
  (expose-scipm-tab "Generic Library Inspector"))

(define-presentation-to-command-translator display-generic-entity
    (generic-entity-presentation com-display-generic-entity-detail scipm-frame
				 :tester ((frame) (not (scipm-frame-edit-mode frame))))
    (object)
  (list object))

(define-scipm-frame-command com-display-generic-entity-detail
    ((ge 'generic-entity-presentation))
  (examine-generic-component ge))

(eval-when (:compile-toplevel :load-toplevel)
  (define-presentation-type generic-process-presentation ()))

(define-presentation-method present (object (type generic-process-presentation)
					    stream (view textual-view) &key)
  (write-string (gp-name object) stream))

(define-scipm-frame-command com-display-generic-process-detail
    ((gp 'generic-process-presentation :gesture :select))
  (examine-generic-component gp))

(eval-when (:compile-toplevel :load-toplevel)
  (define-presentation-type constraint-presentation ()))

(define-presentation-method present (object (type constraint-presentation)
					    stream (view textual-view) &key)
  (write-string (string (constraint-name object)) stream))

(define-scipm-frame-command com-display-constraint-detail
    ((c 'constraint-presentation :gesture :select))
  (examine-generic-component c))

(defun present-generic-library-summary (library stream)
  (let ((entities (lib-entities library))
	(processes (lib-processes library))
	(constraints (lib-constraints library)))
    (with-text-face (stream :bold) (format stream "~A~%" (lib-name library)))
    (with-indent 
	(with-text-face (stream '(:bold :italic)) (format* stream "Entities:~%"))
      (with-indent
	  (loop for e 
	     in entities
	     do (format* stream "")
	       (with-output-as-presentation (stream e 'generic-entity-presentation)
		 (print-ge e stream))
	     (format stream "~%"))))
    (with-indent 
	(with-text-face (stream '(:bold :italic)) (format* stream "Processes:~%"))
      (with-indent
	  (loop for p
	     in processes
	     do (format* stream "")
	       (with-output-as-presentation (stream p 'generic-process-presentation)
		 (print-gp-summary p stream)))))
    (with-indent 
	(with-text-face (stream '(:bold :italic)) (format* stream "Constraints:~%"))
      (with-indent
	  (loop for c
	     in constraints
	     do (with-output-as-presentation (stream c 'constraint-presentation :single-box T)
		  (print-constraint-summary c stream))
		  (format stream "~%"))))))

(defun generic-libraries-list ()
  (sort
   (loop for pathname 
      in (directory (make-pathname :name :wild 
				   :type *generic-file-type*
				   :defaults *generic-library-path*))
      collect 
      ;; strip out links from real files
      (let ((file (handler-case
		      (progn (sb-posix::readlink (pathname-string pathname)) nil)
		    (sb-posix:syscall-error () pathname))))
	(when file 
	  (intern (string-upcase (pathname-name pathname))))))
   #'string-not-greaterp))

(define-presentation-type generic-library-symbol ())

(define-scipm-frame-command com-display-library-summary
    ((sym 'generic-library-symbol :gesture :select))
  (setf (gadget-value (sane-find-pane-named *application-frame* 'library-list)) 
	sym
	(scipm-frame-current-component *application-frame*)
	nil)
  (expose-scipm-tab "Generic Library Inspector"))

(defmethod display-library-summary ((frame scipm-frame) stream)
  (let ((library (get-library-from-filename frame)))
    (when library
      (let ((pane (sane-find-pane-named frame 'library-view)))
	(present-generic-library-summary library stream)
	(setf (window-viewport-position pane) (values 0 0))))))

(defmethod delete-process-from-generic-library (gadget)
  (declare (ignore gadget))
  (let* ((library-interactor (sane-find-pane-named *application-frame* 'library-interactor))
	 (current-library (get-library-from-filename *application-frame*))
	 process)
    (window-clear library-interactor)
    (accepting-values (library-interactor :initially-select-query-identifier 'the-tag)
      (setf process
	    (accept 'generic-process-presentation
		    :stream library-interactor
		    :query-identifier 'the-tag
		    :prompt "Select a process")))
    (window-clear library-interactor)
    (when process
      (let ((lib-view-pane (sane-find-pane-named *application-frame* 'library-view)))
	(remove-process-from-library (string process) current-library)
	(window-clear lib-view-pane)
	(display-library-summary *application-frame* lib-view-pane)))))

(defmethod delete-constraint-from-generic-library (gadget)
  (declare (ignore gadget))
  (let* ((library-interactor (sane-find-pane-named *application-frame* 'library-interactor))
	 (current-library (get-library-from-filename *application-frame*))
	 constraint)
    (window-clear library-interactor)
    (accepting-values (library-interactor :initially-select-query-identifier 'the-tag)
      (setf constraint
	    (accept 'constraint-presentation
		    :stream library-interactor
		    :query-identifier 'the-tag
		    :prompt "Select a constraint")))
    (window-clear library-interactor)
    (when constraint
      (let ((lib-view-pane (sane-find-pane-named *application-frame* 'library-view)))
	(remove-constraint-from-library (string constraint) current-library)
	(window-clear lib-view-pane)
	(display-library-summary *application-frame* lib-view-pane)))))

(defmethod save-current-library (gadget)
  (declare (ignore gadget))
  (let* ((current-library (get-library-from-filename *application-frame*)))
    (if current-library
	(let ((stream (sane-find-pane-named
		       *application-frame* 'library-interactor))
	      (lib-list-pane (sane-find-pane-named *application-frame* 'library-list))
	      (lib-modified (lib-modified current-library))
	      (lib-name (lib-name current-library))
	      (lib-version (get-universal-time)))
	  (window-clear stream)
	  (accepting-values (stream :initially-select-query-identifier 'the-tag)
	    (unless lib-modified
	      (with-text-face (stream :bold) 
		(format stream "No changes to current library,~%~
                              no need to save.~%~%")))
	    (setf lib-name
		  (apply #'accept 'string 
			 :stream stream
			 :prompt "Library Name"
			 (and lib-name (list :default lib-name))))
	    (terpri stream)
	    (setf lib-version
		  (apply #'accept 'string 
			 :stream stream
			 :prompt "Library Version"
			 :query-identifier 'the-tag
			 (and lib-version (list :default lib-version)))))
	  (window-clear stream)
	  (format stream "Running ... ")
	  (stream-force-output stream)
	  (setf (lib-name current-library) lib-name
		(lib-version current-library) lib-version
		(lib-modified current-library) NIL) ; since its saved, it is a new version
					            ; and is not modified relative to that
	  (save-generic-library current-library lib-version)
	  (let ((lib-view-pane (sane-find-pane-named *application-frame* 'library-view)))
	    (window-clear lib-view-pane)
	    (display-library-summary *application-frame* lib-view-pane))
	  (setf (clim-internals::list-pane-items lib-list-pane) (generic-libraries-list))
	  (setf (gadget-value lib-list-pane) (lib-list-filename-from-glib current-library)
		(scipm-frame-current-component *application-frame*)
		nil)
	  (window-clear stream)
	  (format stream "Saved ~A" (lib-name current-library)))
	;; else
	(let ((stream (sane-find-pane-named
		       *application-frame* 'library-interactor)))
	  (window-clear stream)
	  (format stream "Please select existing library~%~
                        from list on left~%~
                        before trying to save the model.")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; instance component detail ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod display-sim-parameter-detail ((frame scipm-frame) stream)
  (let ((object (scipm-frame-current-run-parameter frame)))
    (when object
      (present-scipm-object object frame stream))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; instances commands ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod get-sim-params-and-run (gadget)
  (declare (ignore gadget))
  (if (scipm-frame-current-instance-library *application-frame*)
      (let ((stream (sane-find-pane-named
		     *application-frame* 'run-sim-status))
	    (nmodels (scipm-frame-nmodels *application-frame*)))
	(window-clear stream)
	(accepting-values (stream :initially-select-query-identifier 'the-tag)
	  (setf nmodels
		(apply #'accept 'integer 
		       :stream stream
		       :prompt "Number of models to search for"
		       :query-identifier 'the-tag
		       (and nmodels (list :default nmodels)))))
	(window-clear stream)
	(setf (scipm-frame-nmodels *application-frame*) nmodels)
	(format stream "Running ... ")
	(let ((result-summary
	       (run-scipm-random
		(instance-library-name 
		 (scipm-frame-current-instance-library *application-frame*))
		:nmodels (scipm-frame-nmodels *application-frame*))))
	  (window-clear stream)
	  (format stream "~A" result-summary)))
      ;; else
      (let ((stream (sane-find-pane-named
		     *application-frame* 'run-sim-status)))
	(window-clear stream)
	(format stream "Please choose saved run parameters~%~
                        from list on left~%~
                        before trying to run model search."))))

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; instances summary ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(define-scipm-frame-command com-display-entity-detail
    ((entity 'entity-presentation :gesture :select))
  (make-scipm-tab-contexts-match)
  (setf (scipm-frame-current-run-parameter *application-frame*) entity)
  (expose-scipm-tab "Run Model Search"))

(define-presentation-type instance-library-presentation ())
(define-presentation-type instance-lib-name-presentation ())
(define-presentation-type instance-lib-version-presentation ())

(define-presentation-type instance-data-file-path-presentation ())
(define-presentation-type entity-presentation ())

(define-scipm-frame-command com-display-data-file
    ((file 'instance-data-file-path-presentation :gesture :select))
    (setf (scipm-frame-current-run-parameter *application-frame*) file))

(defmethod present-scipm-object ((object pathname) frame stream)
  (with-text-face (stream :bold) 
    (format stream "First 5 lines of \"~A\":~%  " (pathname-name object)))
  (with-open-file (input object :direction :input)
    (formatting-table 
	(stream :multiple-columns 1 :x-spacing '(2 :character))
      (loop for i from 1 to 5 do
	   (formatting-row (stream)
	     (let ((line (read-line input nil ""))
		   item-list)
	       (with-input-from-string (s line)
		 (loop for x = (read s nil :eof) 
		    if (eq x :eof) 
		    return (reverse item-list)
		    else do (formatting-cell (stream)
			      (if (= i 1)
				  (with-text-face (stream '(:bold :italic))
				    (format stream "~A" x))
				  (format stream "~A" x)))))))))))

(defun display-instance-data-files (file-list frame stream)
  (declare (ignore frame))
  (formatting-table (stream :multiple-columns 1)
    (loop for file 
       in file-list
       do (formatting-row (stream)
	    (formatting-cell (stream)
	      (with-output-as-presentation
		  (stream file 'instance-data-file-path-presentation)
		(format stream "~A" (pathname-name file))))))))

(define-presentation-type variable?-presentation ())
(define-presentation-type constant?-presentation ())

(defmethod present-scipm-object ((object variable?) frame stream)
  (with-output-as-presentation (stream object 'variable?-presentation)
    (formatting-table (stream :multiple-columns 1 :x-spacing '(1 :character))
      (formatting-row (stream)
	(formatting-cell (stream) (format stream "type"))
	(formatting-cell (stream)
	  (format stream "~A"
		    (variable-type-name (slot-value object 'type)))))
      (loop for (field ptype) in '((initial-value float)
				   (upper-bound float)
				   (lower-bound float)
				   (units string)
				   (data-name string)
				   (exogenous string)
				   (aggregator symbol)
				   (comment string))
	 do (formatting-row (stream)
	      (formatting-cell (stream) (format stream "~A" (string field)))
	      (with-output-as-presentation
		  (stream (slot-value object field) ptype)
		(formatting-cell (stream)
		  (format stream "~A" (slot-value object field)))))))))

(defmethod present-scipm-object ((object constant?) frame stream)
  (with-output-as-presentation (stream object 'constant?-presentation)
    (formatting-table (stream :multiple-columns 1 :x-spacing '(1 :character))
      (formatting-row (stream)
	(formatting-cell (stream) (format stream "type"))
	(formatting-cell (stream)
	  (format stream "~A"
		    (constant-type-name (slot-value object 'type)))))
      (loop for (field ptype) in '((initial-value float)
				   (upper-bound float)
				   (lower-bound float)
				   (units string)
				   (comment string))
	 do (formatting-row (stream)
	      (formatting-cell (stream) (format stream "~A" (string field)))
	      (with-output-as-presentation 
		  (stream (slot-value object field) ptype)
		(formatting-cell (stream) 
		  (format stream "~A" (slot-value object field)))))))))

(define-presentation-type entity-name-presentation ())
(define-presentation-type entity-comment-presentation ())

(defmethod present-scipm-object ((object entity) frame stream)
  (with-output-as-presentation (stream object 'entity-presentation :single-box T)
    (with-text-face (stream :bold) (format stream "Entity Instance~%"))
    (with-text-face (stream '(:bold :italic)) (format stream "  Name:  "))
    (with-output-as-presentation (stream (entity-name object) 'entity-name-presentation)
      (format stream "~A" (entity-name object)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Generic Entity (type):  "))
    (with-output-as-presentation 
	(stream (entity-generic-entity object) 'generic-entity-presentation)
      (print-ge (entity-generic-entity object) stream))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Variables:  ~%    "))
    (let ((v-hash (entity-variables object)))
      (when v-hash
	(display-v/c-hash v-hash frame stream)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Constants:  ~%    "))
    (let ((c-hash (entity-constants object)))
      (when c-hash
	(display-v/c-hash c-hash frame stream)))
    (with-text-face (stream '(:bold :italic)) (format stream "~%  Comment:  "))
    (with-output-as-presentation
	(stream (entity-comment object) 'entity-comment-presentation)
      (format stream "~{~A~}" (when (entity-comment object) (list (entity-comment object)))))))

(defun display-instance-entities (entity-list frame stream)
  (declare (ignore frame))
  (formatting-table (stream :multiple-columns 1)
    (loop for entity
       in entity-list
       do (formatting-row (stream)
	    (formatting-cell (stream)
	      (with-output-as-presentation (stream entity 'entity-presentation)
		(print-entity entity stream))))))
  (format stream "~%"))

(defun lib-list-name-from-glib (generic-library)
  (intern 
   (string-upcase 
    (format NIL "~A~{ v. ~A~}" 
	    (lib-name generic-library)
	    (when (lib-version generic-library)
	      (list (lib-version generic-library)))))))

(defun lib-list-filename-from-glib (generic-library)
  (intern 
   (string-upcase 
    (format NIL "~A~{_v_~A~}" 
	    (lib-name generic-library)
	    (when (lib-version generic-library)
	      (list (lib-version generic-library)))))))

(defun present-instance-library-summary (library frame stream)
  (let ((version (instance-library-version library))
	; (modified (instance-library-modified library))
	(name (instance-library-name library))
	(generic-library (instance-library-generic-library library))
	(data-files (instance-library-data-files library))
	(entities (instance-library-entities library)))
    (with-output-as-presentation (stream library 'instance-library-presentation)
      (formatting-table (stream :multiple-columns 1 :y-spacing '(1 :character))
	(formatting-row (stream)
	  (formatting-cell (stream)
	    (with-output-as-presentation (stream name 'instance-lib-name-presentation)
	      (with-text-face (stream :bold) (format stream "~A~%" name))))
	  (when version
	    (formatting-cell (stream)
	      (with-output-as-presentation (stream version 'instance-lib-version-presentation)
		(with-text-face (stream :bold) (format stream "v. ~A~%" version))))))
	(formatting-row (stream)
	  (formatting-cell (stream)
	    (with-text-face (stream :italic) (format stream "Generic Library")))
	  (formatting-cell (stream)
	    (let ((lib-sym (lib-list-filename-from-glib generic-library)))
	      (with-output-as-presentation
		  (stream lib-sym 'generic-library-symbol)
		(format stream "~A" lib-sym)))))
	(formatting-row (stream)
	  (formatting-cell (stream)
	    (with-text-face (stream :italic) (format stream "Data Files")))
	  (formatting-cell (stream)
	    (display-instance-data-files data-files frame stream)))
	(formatting-row (stream)
	  (formatting-cell (stream)
	    (with-text-face (stream :italic) (format stream "Entities")))
	  (formatting-cell (stream)
	    (display-instance-entities entities frame stream)))))))

(defun instance-libraries-list ()
  (sort
   (loop for pathname 
      in (directory (make-pathname :name :wild 
				   :type *instance-file-type*
				   :defaults *instance-library-path*))
      collect (intern (string-upcase (pathname-name pathname))))
  #'string-not-greaterp))

(define-presentation-type instance-library-symbol ())

(define-scipm-frame-command com-display-instance-library-summary
    ((sym 'instance-library-symbol :gesture :select))
  (setf (gadget-value (sane-find-pane-named *application-frame* 'run-par-list)) 
	sym
	(scipm-frame-current-run-parameter *application-frame*)
	nil)
  (expose-scipm-tab "Run Model Search"))

(defmethod display-instance-library-summary ((frame scipm-frame) stream)
  (let* ((lib-list-pane (sane-find-pane-named frame 'run-par-list))
	 (lib-list-value (gadget-value lib-list-pane))
	 (lib-name-version (let* ((lib-name (string lib-list-value))
				  (v? (search "_v_" lib-name :test #'string-equal)))
			     (if v?
				 (list (subseq lib-name 0 v?)
				       (subseq lib-name (+ 3 v?)))
				 (list lib-name nil))))
	 (library (when lib-list-value
		    (instance-library (first lib-name-version)
				      (second lib-name-version)))))
    (when library
      (setf (scipm-frame-current-instance-library frame) library)
      (let ((pane (sane-find-pane-named frame 'run-sim)))
	(present-instance-library-summary library frame stream)
	(format stream "~%")
	(setf (window-viewport-position pane) (values 0 0)) ))))

;;;;;;;;;;;;;;;;;;;;;;;
;;; display results ;;;
;;;;;;;;;;;;;;;;;;;;;;;
(define-presentation-type model-presentation ())

(defmethod display-results-summary ((frame scipm-frame) stream)
  (when *RESULTS*
    (progn
      (with-text-face (stream :bold)
	(format stream "Results from:~%"))
      (formatting-table (stream :multiple-columns 1)
	(formatting-row (stream)
	  (formatting-cell (stream)
	    (with-text-face (stream :italic)
	      (format stream "Instance Library")))
	  (formatting-cell (stream)
	    (with-output-as-presentation 
		(stream (keyword-value :instance-library-name *RESULTS*)
			'instance-library-symbol)
	      (format stream "~A" 
		      (keyword-value :instance-library-name *RESULTS*)))))
	(formatting-row (stream)
	  (formatting-cell (stream)
	    (with-text-face (stream :italic)
	      (format stream "Generic Library")))
	  (formatting-cell (stream)
	      (let* ((gen-lib (instance-library-generic-library
			       (instance-library (keyword-value 
						  :instance-library-name
						  *RESULTS*))))
		     (lib-sym
		      (lib-list-filename-from-glib gen-lib)))
		(with-output-as-presentation
		    (stream lib-sym 'generic-library-symbol)
		  (format stream "~A" lib-sym)))))
	;; model search
	(formatting-row (stream)
	  (formatting-cell (stream)
	    (with-text-face (stream :italic)
	      (format stream "Model Search Algorithm")))
	  (formatting-cell (stream)
	    (format stream "~A" (keyword-value :search-routine *RESULTS*))))
	;; simulation routine
	(formatting-row (stream)
	  (formatting-cell (stream)
	    (with-text-face (stream :italic)
	      (format stream "Model Simulation Algorithm")))
	  (formatting-cell (stream)
	    (format stream "~A" (keyword-value :sim-routine  *RESULTS*)))))
      ;; model results
      (format stream "~%~%")
      (formatting-table (stream :multiple-columns 1 :x-spacing '(2 :character))
	(formatting-row (stream)
	  (formatting-cell (stream)
	    (with-text-face (stream :bold) 
	      (format stream "~%~%Model~%")))
	  (formatting-cell (stream)
	    (with-text-face (stream :bold) 
	      (format stream "~%~%Score~%"))))
	(loop for (model params score sim)
	   in (keyword-value :model-results *RESULTS*)
	   do (formatting-row (stream)
		(formatting-cell (stream)
		  (with-output-as-presentation (stream (list model params)
						       'model-presentation)
		    (format stream "~A" (model-name model))))
		(formatting-cell (stream)
		  (format stream "~D" score)))))
      (format stream "~%"))))

(define-scipm-frame-command com-display-model-details
    ((model&params 'model-presentation :gesture :select))
    (setf (scipm-frame-current-result-model *application-frame*) (first model&params)
	  (scipm-frame-current-result-params *application-frame*) (second model&params)))

(define-presentation-type process-instance-presentation ())

(defun present-pi-summary (p-i stream)
  (let (first-er
	first-e
	(ents (process-entity-roles p-i)))
    (with-output-as-presentation (stream p-i 'process-instance-presentation :single-box T)
      (with-output-as-presentation (stream (process-generic-process p-i) 
					   'generic-process-presentation)
	(format stream "~A(" (gp-name (process-generic-process p-i))))
      (setf first-er t)
      (dolist (er ents)
	(setf first-e t)
	;; role name
	(format stream "~A~A:{" (if first-er 
				    (progn (setf first-er nil) "")
				    ", ")
		(car er))
	(dolist (e (second er))
	  ;; entities assigned to role
	  (with-output-as-presentation (stream e 'entity-presentation)
	    (format stream "~A~A" (if first-e
				      (progn (setf first-e nil) "")
				      " ")
		    (entity-name e))))
	(format stream "}"))
      (format stream ")"))))

(defun display-parameters (param-val-list stream)
  (formatting-table (stream :multiple-columns 1)
    (loop for (p v)
       in param-val-list
       do (formatting-row (stream)
	    (formatting-cell (stream)
	      (format stream "~A" p))
	    (formatting-cell (stream)
	      (format stream "~6,4,1E" v))))))

(defun present-entity-summary (entity stream)
  (format stream "~A" (entity-name entity))
  (with-output-as-presentation (stream (entity-generic-entity entity)
				       'generic-entity-presentation)
    (format stream "{~A}" (generic-entity-type (entity-generic-entity entity)))))


(defun display-instance-entities-params (entities frame stream)
  (let ((obj-name-val-list (process-entity-parameters 
			    (scipm-frame-current-result-model frame)
			    (scipm-frame-current-result-params frame))))
    (formatting-table (stream :multiple-columns 1 :y-spacing '(1 :character))
      (loop for entity
	 in entities
	 for entity-params = (loop for (obj name val)
				in obj-name-val-list
				when (eq obj entity)
				collect (list (constant-type-name (constant?-type name))
					      val))
	 do (formatting-row (stream)
	      (formatting-cell (stream)
		(with-output-as-presentation (stream entity 'entity-presentation
						     :single-box T)
		  (present-entity-summary entity stream)))
	      (when entity-params
		(formatting-cell (stream)
		  (display-parameters entity-params stream)))))))
  (format stream "~%"))

(defun display-process-instances-params (processes frame stream)
  (let ((obj-name-val-list (process-entity-parameters 
			    (scipm-frame-current-result-model frame)
			    (scipm-frame-current-result-params frame))))
    (formatting-table (stream :multiple-columns 1 :y-spacing '(1 :character))
      (loop for process
	 in processes
	 for process-params = (loop for (obj name val)
				 in obj-name-val-list
				 when (eq obj process)
				 collect (list (constant-type-name (constant?-type name))
					       val))
	 do (formatting-row (stream)
	      (formatting-cell (stream)
		(with-output-as-presentation (stream process 'process-instance-presentation)
		  (present-pi-summary process stream)))
	      (when process-params
		(formatting-cell (stream)
		  (display-parameters process-params stream)))))))
  (format stream "~%"))

(defmethod present-scipm-object ((object model) frame stream)
  (formatting-table (stream :multiple-columns 1 :y-spacing '(1 :character))
    (formatting-row (stream)
      (with-text-face (stream '(:bold :italic))
	(formatting-cell (stream) (format stream "Name")))
      (formatting-cell (stream) (format stream "~A" (model-name object))))
    ;; Entities
    (formatting-row (stream)
      (formatting-cell (stream)
	(with-text-face (stream '(:bold :italic)) (format stream "Entities")))
      (formatting-cell (stream)
	(display-instance-entities-params (model-entities object)
				   *application-frame* stream)))
    ;; Processes
    (formatting-row (stream)
      (formatting-cell (stream) (with-text-face (stream '(:bold :italic))
				  (format stream "Processes")))
      (formatting-cell (stream)
	(display-process-instances-params (model-processes object)
				   *application-frame* stream)))))

(defmethod display-results-details ((frame scipm-frame) stream)
  (let ((model (scipm-frame-current-result-model frame)))
    (when model
      (with-text-face (stream :bold)
	(format stream "Model~%"))
      (present-scipm-object model frame stream)
      (format stream "~%"))))

(defun simple-accept-new-process (gadget)
  (declare (ignore gadget))
  (let ((library (get-library-from-filename *application-frame*))
	(stream (sane-find-pane-named
		 *application-frame* 'library-interactor)))
    (if library
	(let ((name ""))
	  (window-clear stream)
	  (accepting-values (stream :initially-select-query-identifier 'the-tag)
	    (setf name
		  (apply #'accept 'string
			 :stream stream
			 :prompt "New Process Name"
			 :query-identifier 'the-tag
			 (and name (list :default name)))))
	  (window-clear stream)
	  ;; if we got a new process ... add it to the library and redisplay
	  (when name
	    (let ((lib-view-pane (sane-find-pane-named *application-frame* 'library-view)))
	      (setf (lib-processes library)
		    (append (lib-processes library)
			    (list (create-generic-process :name name))))
	      (window-clear lib-view-pane)
	      (display-library-summary *application-frame* lib-view-pane))))
	;; else
	(let ((stream (sane-find-pane-named
		       *application-frame* 'library-interactor)))
	  (window-clear stream)
	  (format stream "Please choose Generic Library~%~
                        from list on left~%~
                        to add a new Generic Process to")))))

(defun simple-accept-new-constraint (gadget)
  (declare (ignore gadget))
  (let ((library (get-library-from-filename *application-frame*))
	(stream (sane-find-pane-named
		 *application-frame* 'library-interactor)))
    (if library
	(let ((name ""))
	  (window-clear stream)
	  (accepting-values (stream :initially-select-query-identifier 'the-tag)
	    (setf name
		  (apply #'accept 'string
			 :stream stream
			 :prompt "New Constraint Name"
			 :query-identifier 'the-tag
			 (and name (list :default name)))))
	  (window-clear stream)
	  ;; if we got a new constraint ... add it to the library and redisplay
	  (when name
	    (let ((lib-view-pane (sane-find-pane-named *application-frame* 'library-view)))
	      (setf (lib-constraints library)
		    (append (lib-constraints library)
			    (list (make-constraint :name (intern (string-upcase name))))))
	      (window-clear lib-view-pane)
	      (display-library-summary *application-frame* lib-view-pane))))
	;; else
	(let ((stream (sane-find-pane-named
		       *application-frame* 'library-interactor)))
	  (window-clear stream)
	  (format stream "Please choose Generic Library~%~
                        from list on left~%~
                        to add a new Constraint to")))))

;;; Modify/Copy generic library item

(defgeneric copy-and-insert-component (component frame))

(gen-copy-and-insert-component generic-entity)
(gen-copy-and-insert-component generic-process)
(gen-copy-and-insert-component constraint)

(defun display-button (label type stream)
  (with-output-as-presentation (stream nil type)
    (with-drawing-options (stream :ink (if (and (scipm-frame-edit-mode *application-frame*)
						(member type '(copy-button delete-button)))
					   +light-gray+
					   +black+)
				  :text-face :bold :text-size :large)
      (format stream "~A" label))))

;;;

(create-scipm-component-action-button "Copy" copy inspect copy-and-insert-component)
(create-scipm-component-action-button "Inspect" inspect edit exit-edit-component-mode)
(create-scipm-component-action-button "Edit" edit inspect enter-edit-component-mode)
(create-scipm-component-action-button "Delete" delete inspect remove-component-from-library)

(create-scipm-component-action-button "Add" add-entity-role edit accept-new-entity-role)
(create-scipm-component-action-button "Add" add-constant edit accept-new-constant)
(create-scipm-component-action-button "Add" add-equation edit accept-new-equation)
(create-scipm-component-action-button "Delete" delete-entity-role edit delete-entity-role)
(create-scipm-component-action-button "Delete" delete-constant edit delete-constant)
(create-scipm-component-action-button "Delete" delete-equation edit delete-equation)

(create-scipm-component-action-button "Add" add-constraint-item edit
				      accept-new-constraint-item)
(create-scipm-component-action-button "Delete" delete-constraint-item edit
				      delete-constraint-item)

(defgeneric remove-component-from-library (component frame))

(defmethod remove-component-from-library ((component generic-process) frame)
  (remove-process-from-library (gp-name component) (get-library-from-filename frame)))

(defmethod remove-component-from-library ((component constraint) frame)
  (remove-constraint-from-library (constraint-name component) (get-library-from-filename frame)))

(defmethod remove-component-from-library :after (component frame)
  (setf (scipm-frame-current-component frame) NIL))

(defmethod remove-component-from-library ((component generic-entity) frame)
  (declare (ignore component frame)))

(defun exit-edit-component-mode (component frame)
  (declare (ignore component))
  (setf (scipm-frame-edit-mode frame) nil))

(defun enter-edit-component-mode (component frame)
  (declare (ignore component))
  (setf (scipm-frame-edit-mode frame) T))

(defmethod accept-new-entity-role (component frame)
  (let ((stream (sane-find-pane-named frame 'library-interactor))
	(er-name nil)
	(er-types nil))
    (window-clear stream)
    ;; accept raw values as strings
    (accepting-values (stream)
      (setf er-name
	    (apply #'accept 'string :stream stream :prompt "Role ID"
		   (when er-name (list :default er-name))))
      (fresh-line stream)
      (setf er-types
	    (apply #'accept 'string :stream stream :prompt "Types"
		   (when er-types (list :default er-types)))))
    (window-clear stream)
    ;; turn raw values into entity-roles and add to component (generic-process)
    (if (and er-types er-name)
	(let* ((er-type-strings
		(with-input-from-string (str er-types)
		  (loop for x = (read str nil :eof)
		     until (eq x :eof)
		     collect (string-trim '(#\space) (string x)))))
	       (er-type-entities
		(loop for str
		   in er-type-strings
		   collect (find-entity str
					(lib-entities 
					 (get-library-from-filename frame))))))
	  (if (member nil er-type-entities)
	      (format stream "One of ~A not an entity named in this library" er-type-strings)
	      (push (cons er-name (make-entity-role :name er-name :types er-type-entities))
		    (gp-entity-roles component))))
	(format stream "Must supply a value for ~A~%" 
		(cond (er-types "er-name") (er-name "er-types"))))))

(defun remove-entity-role-from-gp (gp entity-role-name-str)
  (setf (gp-entity-roles gp) (remove entity-role-name-str (gp-entity-roles gp) 
				     :key #'car
				     :test #'string-equal)))

(defmethod delete-entity-role (component frame)
  (let ((stream (sane-find-pane-named frame 'library-interactor))
	entity-role)
    (window-clear stream)
    ;; accept raw values as strings
    (accepting-values (stream :initially-select-query-identifier 'the-tag)
      (setf entity-role 
      (accept 'entity-role-presentation
	      :stream stream
	      :query-identifier 'the-tag
	      :prompt "Select Entity Role to delete")))
    (window-clear stream)
    (when entity-role
      (remove-entity-role-from-gp component (string entity-role)))))

(defun remove-constant-from-gp (gp constant-name-str)
  (remhash constant-name-str (gp-constants gp)))

(defmethod delete-constant (component frame)
  (let ((stream (sane-find-pane-named frame 'library-interactor))
	constant)
    (window-clear stream)
    ;; accept raw values as strings
    (accepting-values (stream :initially-select-query-identifier 'the-tag)
      (setf constant
	    (accept 'ge-constant-presentation
		    :stream stream
		    :query-identifier 'the-tag
		    :prompt "Select Constant to delete")))
    (window-clear stream)
    (when constant
      (remove-constant-from-gp 
       component
       ;; for some reason, clim returns the value as a symbol, not a string, 
       ;; and it doesn't preserve capitaliztion in the symbol, so the (string constant)
       ;; always results in upper case. So we assume none of the keys will be 
       ;; string-equal with each other ...
       (loop for key in (hash-table-keys (gp-constants component))
	  when (string-equal key (string constant))
	  return key)))))

(defun remove-constraint-modifier-from-constraint (component item-str)
  ;; component is a constraint
  (with-input-from-string (str item-str)
    (let* ((gprocess (string (read str)))
	   (conmods (read str nil nil))
	   (new-items (loop for item in (constraint-items component)
			 unless (and (string-equal (gp-name (conmod-gprocess item)) gprocess)
				     (or (null conmods)
					  (equal conmods (conmod-modifiers item))))
			 collect item)))
      (setf (constraint-items component) new-items))))

(defmethod delete-constraint-item (component frame)
  (let ((stream (sane-find-pane-named frame 'library-interactor))
	item)
    (window-clear stream)
    ;; accept raw values as strings
    (accepting-values (stream :initially-select-query-identifier 'the-tag)
      (setf item
      (accept 'constraint-item-presentation
	      :stream stream
	      :query-identifier 'the-tag
	      :prompt "Select Constraint Item to delete")))
    (window-clear stream)
    (when item
      (remove-constraint-modifier-from-constraint component (string item)))))

(defmethod accept-new-constraint-item (component frame)
  (let ((stream (sane-find-pane-named frame 'library-interactor))
	gprocess
	conmods)
    (window-clear stream)
    (accepting-values (stream :initially-select-query-identifier 'the-tag)
      (setf gprocess
	    (accept 'generic-process-presentation
		    :stream stream
		    :query-identifier 'the-tag
		    :prompt "Select a process" #+IGNORE
		    (and gprocess (list :default gprocess))))
      ;; accept raw values as strings
      (when gprocess
	(fresh-line stream)
	(setf conmods
	      (let ((prompt-string (format NIL "Enter ((id1 . \"role-name1\") ... ),~%~
                             where role-name must be one of ~A~%~
                             like ((A . \"P1\") (B . \"P2\"))"
					   (loop for (ignore . entity-role)
					      in (gp-entity-roles 
						  (if (eq (type-of gprocess) 'generic-process)
						      gprocess
						      (gp-named (string gprocess) frame)))
					      collect (entity-role-name entity-role)))))
		(apply #'accept 'expression
		       :stream stream
		       :prompt prompt-string
		       (and conmods (list :default conmods)))))))
    (window-clear stream)
    (push (make-constraint-modifier
	   :gprocess (if (eq (type-of gprocess) 'generic-process)
						  gprocess
						  (gp-named (string gprocess) frame))
	   :modifiers conmods)
	  (constraint-items component))))

(defun remove-equation-from-gp (gp equation-var-name-str)
  (setf (gp-equations gp) (remove equation-var-name-str (gp-equations gp) 
				     :key #'(lambda (x) (slot-value x 'variable))
				     :test #'string-equal)))

(defmethod delete-equation (component frame)
  (let ((stream (sane-find-pane-named frame 'library-interactor))
	equation)
    (window-clear stream)
    ;; accept raw values as strings
    (accepting-values (stream :initially-select-query-identifier 'the-tag)
      (setf equation
      (accept 'equation-presentation
	      :stream stream
	      :query-identifier 'the-tag
	      :prompt "Select Entity Role to delete")))
    (window-clear stream)
    (when equation
      (remove-equation-from-gp component (string equation)))))

(defmethod accept-new-constant (component frame)
  (let ((stream (sane-find-pane-named frame 'library-interactor))
	(constant-name nil)
	(c-lower-b nil)
	(c-upper-b nil)
	(c-units nil)
	(c-comment nil))
    (window-clear stream)
    ;; accept raw values as strings
    (accepting-values (stream :initially-select-query-identifier 'the-tag)
      (setf constant-name
	    (string-trim '(#\space)
			 (apply #'accept 'string :stream stream :prompt "Constant ID"
				:query-identifier 'the-tag
				(and constant-name (list :default constant-name)))))
      (terpri stream)
      (setf c-lower-b
	    (apply #'accept '(or rational float null) :stream stream :prompt "Lower Bound"
		   (and c-lower-b (list :default c-lower-b))))
      (terpri stream)
      (setf c-upper-b
	    (apply #'accept '(or rational float null) :stream stream :prompt "Upper Bound"
		   (and c-upper-b (list :default c-upper-b))))
      (terpri stream)
      (setf c-units
	    (string-trim '(#\space)
			 (apply #'accept 'string :stream stream :prompt "Constant Units"
				(and c-units (list :default c-units)))))
      (terpri stream)
      (setf c-comment
	    (string-trim '(#\space)
			 (apply #'accept 'string :stream stream :prompt "Constant Comment"
				(and c-comment (list :default c-comment))))))
    ;; raw values into a constant
    (if (string-equal "" constant-name)
	(format stream "Must supply a value for CONSTANT-NAME.")
	(let* ((constants-defn-raw (list :name constant-name :upper-bound c-upper-b
					 :lower-bound c-lower-b :units c-units
					 :comment c-comment))
	       (constants-defn (loop for (key value) on constants-defn-raw by #'cddr
				  when value
				  append (list key value)))
	       (constant (apply #'make-constant-type (prepare-constant-args constants-defn))))
	  (setf (gethash (constant-type-name constant) (gp-constants component)) constant)))))

(defmethod accept-new-equation (component frame)
  (let ((stream (sane-find-pane-named frame 'library-interactor))
	(eqn-type nil)
	(eqn-var nil)
	(eqn-rhs nil))
    (window-clear stream)
    ;; accept raw values as strings
    (accepting-values (stream :initially-select-query-identifier 'the-tag)
      (setf eqn-type
	    (apply #'accept '(or (member ode alg) null) :stream stream
		   :prompt "Equation Type (ODE or ALG)"
		   (list :default eqn-type)))
      (terpri stream)
      (setf eqn-var
	    (string-trim '(#\space)
			 (apply #'accept 'string :stream stream :prompt "Variable"
				(list :default eqn-var))))
      (terpri stream)
      (setf eqn-rhs
	    (string-trim '(#\space)
			 (apply #'accept 'string :stream stream :prompt "RHS"
				(list :default eqn-rhs)))))
    ;; raw values into equation and insert into process
    (if (and eqn-type eqn-var eqn-rhs)
	(let* ((eqn-raw (list :variable eqn-var
			      :rhs (with-input-from-string (str eqn-rhs)
				     (loop for x = (read str nil :eof)
					until (eq x :eof)
					append x))))
	       (eqn (if (eq eqn-type 'ODE)
			(apply #'make-differential-equation eqn-raw)
			;; (eq eqn-type 'ALG)
			(apply #'make-algebraic-equation eqn-raw))))
	  (push eqn (gp-equations component)))
	(format stream "Must specify values for Equation Type, Variable,~
                    and RHS (right-hand side)))."))))
