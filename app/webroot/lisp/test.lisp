#|
(let ((best 1000) (tmp))
  (dotimes (i 100 best) 
    (setf predprey (random-structure sg))
    (setf tmp (test-717-rk4))
    (if (< (second tmp) best) 
	(setf best (second tmp)))))
|#

(load "test_runs/predprey-run.lisp")

;; use 'rk4 or 'cvode
(defun test-scipm (sim-routine)
  (run-scipm-random pp-lib (list 
			    (make-pathname :name "pp-sim" :type "data"
					   :directory "/Users/rab/scipm/"))
                    (list prey predator) :nmodels 5 
                    :nrestarts-full 2 
                    :sim-routine sim-routine)    
)

