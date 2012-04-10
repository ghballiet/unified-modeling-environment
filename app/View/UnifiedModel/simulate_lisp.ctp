<?
// get the id
$model_id = $model['UnifiedModel']['id'];
$data = $exogenous_data['ExogenousValue']['value'];

// generate the data file
$step_size = $exogenous_data['ExogenousValue']['step_size'];
$steps = intval($exogenous_data['ExogenousValue']['steps']);
if($steps == null)
  $steps = 1;
$data = array();
$header = array();
$defaults = array();
$columns = 1;

// build the header and default value rows
$header[] = 'time';
$defaults[] = 0;
$grain = 1000.0;
foreach($generic_entities as $ge) {
  $instances = intval($ge['GenericEntity']['instances']);
  $name = $ge['GenericEntity']['name'];
  $attrs = $variables[$ge['GenericEntity']['id']];
  for($i=1; $i<=$instances; $i++) {
    foreach($attrs as $a) {
      $attr_name = $a['GenericAttribute']['name'];
      $lower_bound = $a['GenericAttribute']['lower_bound'];
      $upper_bound = $a['GenericAttribute']['upper_bound'];
      $column = sprintf('%s%s.%s', $name, $i, $attr_name);
      $header[] = $column;
      if($attr_name == 'target') {
        $rand = rand(intval($lower_bound), intval($upper_bound));
      } else {
        $rand = rand(floatval($lower_bound) * $grain, floatval($upper_bound) * $grain);
        $rand = $rand / $grain;
      }
      $defaults[] = $rand;
    }
  }
}
$data[0] = $header;
$data[1] = $defaults;

// add the partial timesteps for the default row
$inc = 1.0 / floatval($step_size);
for($i=1; $i<$step_size; $i++) {
  $row = array();
  $row[] = $inc * $i;
  foreach($generic_entities as $ge) {
    $instances = intval($ge['GenericEntity']['instances']);
    $attrs = $variables[$ge['GenericEntity']['id']];
    for($j=1; $j<=$instances; $j++) {
      foreach($attrs as $a)
        $row[] = 0;
    }
  }
  $data[] = $row;
}

for($i=1; $i<=$steps; $i++) {
  $row = array();  
  $row[] = $i;
  foreach($generic_entities as $ge) {
    $instances = intval($ge['GenericEntity']['instances']);
    $attrs = $variables[$ge['GenericEntity']['id']];
    for($j=1; $j<=$instances; $j++) {
      foreach($attrs as $a)
        $row[] = 0;
    }
  }

  $data[] = $row;

  // build out the other partial timesteps
  $increment = 1.0 / floatval($step_size);
  for($k=1; $k<$step_size; $k++) {
    $trow = array();
    $trow[] = $i + ($increment * $k);
    foreach($generic_entities as $ge) {
      $instances = intval($ge['GenericEntity']['instances']);
      $attrs = $variables[$ge['GenericEntity']['id']];
      for($j=1; $j<=$instances; $j++) {
        foreach($attrs as $a)
          $trow[] = 0;
      }
    }
    $data[] = $trow;
  }
}

$lines = array();
foreach($data as $row)
  $lines[] = implode(' ', $row);

$full = implode("\n", $lines);

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
file_put_contents($data_file, $full);

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
$cmd = sprintf('ulimit -t 60; sbcl --core sbcl.core --script %s > %s 2> %s', $lisp_file, $output_file, $error_file);
// $cmd = sprintf('sbcl --core sbcl.core --script %s > %s 2> %s', $lisp_file, $output_file, $error_file);
$results = shell_exec($cmd);

$output = file_get_contents($output_file);
$errors = file_get_contents($error_file);

if($output == '') {
  echo "ERROR: ";
  echo $errors;
} else {
  echo $output;
}

// delete the files
// unlink($glib_file);
// unlink($ilib_file);
// unlink($data_file);
// unlink($output_file);
// unlink($lisp_file);
// unlink($error_file);
?>