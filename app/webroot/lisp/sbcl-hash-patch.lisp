(in-package :scipm)

(declaim (inline scipm::make-hash-table))

(defun scipm::make-hash-table (&rest keys)
  (apply #'cl:make-hash-table :synchronized t keys))
