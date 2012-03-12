<?
// get the id
$model_id = $model['UnifiedModel']['id'];
$data = $exogenous_data['ExogenousValue']['value'];

// build the urls
$hostname = sprintf('http://%s', strtolower(php_uname('n')));
$generic_url = $hostname . $this->Html->url(array('action'=>'lisp_generic', $model_id));
$concrete_url = $hostname . $this->Html->url(array('action'=>'lisp_concrete', $model_id));

// grab the file contents
$generic_contents = file_get_contents($generic_url);
$concrete_contents = file_get_contents($concrete_url);
$output_dir = sprintf('%s/lisp/', getcwd());

// create the data files
$file_prefix = 'DATA-' . $model_id;
$glib_file = sprintf('%s%s.glib', $output_dir, $file_prefix);
$ilib_file = sprintf('%s%s.ilib', $output_dir, $file_prefix);
$data_file = sprintf('%s%s.data', $output_dir, $file_prefix);
$lisp_file = sprintf('%s%s.lisp', $output_dir, $file_prefix);
$output_file = sprintf('%s%s.output', $output_dir, $file_prefix);
$error_file = sprintf('%s%s.err', $output_dir, $file_prefix);

// write to the data files
file_put_contents($glib_file, $generic_contents);
file_put_contents($ilib_file, $concrete_contents);
file_put_contents($data_file, $data);

// write to the lisp file
$lisp_content = '
(push :non-pe-sim *features*)
(in-package :scipm)
(require :yason)
(defun join-into-string (arg)
  (format nil "[~{\'~A\',~^~}]" arg))

(run-scipm-random :data-' . $model_id . ' :nmodels 1)
(let* ((output-result (car (keyword-value :model-results *results*)))
       (output-data (car (cadddr output-result)))
       (output-model (car output-result))
       (output-rows nil)
       (row-count 0))
  (format t "var data = {};~%")
  (format t "data.id_name = \'~A\';~%" (data-id-name output-data))
  (format t "data.names = ~A;~%" (join-into-string (data-names output-data)))
  (format t "data.values = [];~%")
  (loop for i across (data-values output-data) do
        (let ((row nil))
          (loop for j across i do
                (push j row))
          (setq row (reverse row))
          (format t "data.values[~A] = ~A;~%" row-count (join-into-string row))
          (setq row-count (+ 1 row-count)))))';
file_put_contents($lisp_file, $lisp_content);

// start doin' some lisp stuff
chdir($output_dir);
// added ulimit in order to make sure we don't get any runaway processes
$cmd = sprintf('ulimit -t 8; sbcl --core sbcl.core --script %s > %s 2> %s', $lisp_file, $output_file, $error_file);
$results = shell_exec($cmd);
echo file_get_contents($output_file);

// delete the files
unlink($glib_file);
unlink($ilib_file);
unlink($data_file);
unlink($output_file);
unlink($lisp_file);
// unlink($error_file);
?>