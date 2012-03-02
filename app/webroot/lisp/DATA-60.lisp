
(push :non-pe-sim *features*)
(in-package :scipm)
(require :yason)
(defun join-into-string (arg)
  (format nil "[~{'~A',~^~}]" arg))

(run-scipm-random :data-60 :nmodels 1)
(let* ((output-result (car (keyword-value :model-results *results*)))
       (output-data (car (cadddr output-result)))
       (output-model (car output-result))
       (output-rows nil)
       (row-count 0))
  (format t "var data = {};~%")
  (format t "data.id_name = '~A';~%" (data-id-name output-data))
  (format t "data.names = ~A;~%" (join-into-string (data-names output-data)))
  (format t "data.values = [];~%")
  (loop for i across (data-values output-data) do
        (let ((row nil))
          (loop for j across i do
                (push j row))
          (setq row (reverse row))
          (format t "data.values[~A] = ~A;~%" row-count (join-into-string row))
          (setq row-count (+ 1 row-count)))))