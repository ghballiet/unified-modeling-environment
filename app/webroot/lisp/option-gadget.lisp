(in-package :scipm)

;;;; GENERALLY USEFUL

(defun sane-find-pane-named (frame name)
  (find name
	(climi::frame-named-panes frame)
	:key #'pane-name
	:test #'string-equal))

;;;; SCIPM OPTION PANE

(defclass scipm-option-pane (generic-option-pane)
  ((associated-display-pane :initarg :associated-display-pane)
   (default-prompt :initform "Select a value" :initarg :default-prompt)))

(defmethod initialize-instance :after ((object scipm-option-pane) &rest rest)
  (declare (ignore rest))
  (when (string-equal (slot-value object 'climi::current-label) "")
    (setf (slot-value object 'climi::current-label) (slot-value object 'default-prompt))))
  
(defmethod (setf gadget-value) :after (new-value (gadget scipm-option-pane)
						 &key &allow-other-keys)
  (declare (ignore new-value))
  (when (string-equal (slot-value gadget 'climi::current-label) "")
    (setf (slot-value gadget 'climi::current-label) (slot-value gadget 'default-prompt)))
  (redisplay-frame-pane *application-frame* 
			(find (slot-value gadget 'associated-display-pane)
			      (climi::frame-named-panes *application-frame*)
			      :key #'pane-name :test #'string-equal)))

