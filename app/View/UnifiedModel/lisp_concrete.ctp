<?
printf(";; @name %s\n", $model['UnifiedModel']['name']);
printf(";; @desc %s\n", $model['UnifiedModel']['description']);
$email = $model['User']['email'];
$email = str_replace('@', ' at ', $email);
$email = str_replace('.', ' dot ', $email);
printf(";; @auth %s (%s)\n", $model['User']['name'], $email);
?>

(in-package :scipm)

<?
printf("(create-instance-library data-%d\n", $model['UnifiedModel']['id']);
printf("  :generic-library (:name data-%d)\n", $model['UnifiedModel']['id']);
printf("  :data-file-list (\"DATA-%s\")\n\n", $model['UnifiedModel']['id']);

// ---- entities ----
printf("  ;; ---- entities ----\n");
printf("  :entities\n  (");
foreach($generic_entities as $ge) {
  // do some variable initialization
  $id = $ge['GenericEntity']['id'];
  $name = $ge['GenericEntity']['name'];
  $instances = intval($ge['GenericEntity']['instances']);
  if(isset($generic_variables[$id]))
    $variables = $generic_variables[$id];
  else
    $variables = array();
  if(isset($generic_constants[$id]))
    $constants = $generic_constants[$id];
  else
    $constants = array();

  $i = 0;

  // actually print out the entities
  for($j=1; $j<=$instances; $j++) {
    if($i != 0)
      printf("   ");
    
    printf("(:type \"%s%s\" :generic-type \"%s\"\n", $name, $j, $name);
    
    // variables
    $vars_seen = array();
    printf('    :variables (');
    foreach($variables as $k=>$var) {
      $attr = $var['GenericAttribute']['name'];
      $attr_id = $var['GenericAttribute']['id'];
      if(in_array($attr_id, $vars_seen))
        continue;
      $vars_seen[] = $attr_id;
      if($k!=0)
        printf("                ");
      printf('(:type "%s" :aggregator sum :data-name "%s%s.%s")', $attr, $name, $j, $attr);             
      if($k != sizeof($variables) - 1)
        printf("\n");
    }
    printf(")\n"); // end variables

    // constants
    printf('    :constants (');
    // set the id
    printf('(:type "id" :initial-value %d)', $j);
    if(isset($generic_constants[$id])) {
      if(sizeof($generic_constants[$id]) > 0)
        printf("\n");
      foreach($generic_constants[$id] as $i=>$gc) {
        $attr = $gc['GenericAttribute'];
        $const_name = $attr['name'];
        $lower = floatval($attr['lower_bound']);
        $upper = floatval($attr['upper_bound']);
        $amt = 100.0;
        $val = rand($lower * $amt, $upper * $amt) / $amt;
        printf("                ");
        printf('(:type "%s" :initial-value "%s")', $const_name, $val);
        //printf('(:type "%s")', $const_name);
        if($i != sizeof($generic_constants))
          printf("\n");
      }
    }
    printf(')');
    printf(")\n"); // end entity
    $i++;
  }
}
printf(")"); // end of entities

printf(")")  // end of instance library
?>