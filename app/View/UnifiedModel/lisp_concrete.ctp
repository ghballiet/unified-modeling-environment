(in-package :scipm)

<?
printf("(create-instance-library data-%d\n", $model['UnifiedModel']['id']);
printf("  :generic-library (:name data-%d)\n", $model['UnifiedModel']['id']);
printf("  :data-file-list (\"DATA-%s\")\n\n", $model['UnifiedModel']['id']);

// ---- entities ----
printf("  ;; ---- entities ----\n");
printf("  :entities\n  (");
foreach($concrete_entities as $i=>$ce) {
  if($i != 0)
    printf("   ");
  printf("(:type \"%s\"", $ce['ConcreteEntity']['name']);
  printf(" :generic-type \"%s\"\n", $ce['GenericEntity']['name']);
  printf("    :variables (");

  // ---- variables ---- 
  if(isset($concrete_variables[$ce['ConcreteEntity']['id']])) {
    $varlist = array();
    foreach($concrete_variables[$ce['ConcreteEntity']['id']] as $cv) {
      if(!in_array($cv['ConcreteAttribute']['name'], $varlist))
        $varlist[] = $cv['ConcreteAttribute']['name'];
    }
    foreach($varlist as $j=>$var) {
      if($j != 0)
        printf("                ");
      printf('(:type "%s" :aggregator sum :data-name "%s.%s")', $var, $ce['ConcreteEntity']['name'], $var);
      if($j != sizeof($varlist) - 1)
        printf("\n");
    }
  }
  printf(")\n"); // end of variables

  // ---- constants ----
  printf("    :constants (");
  if(isset($concrete_constants[$ce['ConcreteEntity']['id']])) {
    foreach($concrete_constants[$ce['ConcreteEntity']['id']] as $j=>$cc) {
      if($j != 0)
        printf("                ");
      printf('(:type "%s" :initial-value %s)', $cc['ConcreteAttribute']['name'], $cc['ConcreteAttribute']['value']);
      if($j != sizeof($concrete_constants[$ce['ConcreteEntity']['id']]) - 1)
        printf("\n");
    }
  }
  printf(")"); // end of constants
  
  printf(")"); // end of entity
  if($i != sizeof($concrete_entities) - 1)
    printf("\n");
}
printf(")"); // end of entities

// ---- processes ----
// printf("\n\n  ;; ---- processes ----\n");

printf(")")  // end of instance library
?>