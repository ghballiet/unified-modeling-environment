(in-package :scipm)

(create-generic-library data-<? echo $model['UnifiedModel']['id']; ?>

  ;; ---- entities ----
  :entity-list
  (<?
foreach($generic_entities as $l=>$ge) {
  if($l!=0)
    printf("   ");
  printf("(:type \"%s\"\n", $ge['GenericEntity']['name']);
  
  
  // ---- variables ----
  $varlist = array();
  printf("    :variables (");
  
  if(isset($generic_variables[$ge['GenericEntity']['id']])) {
    foreach($generic_variables[$ge['GenericEntity']['id']] as $i=>$gv) {
      if(!in_array($gv['GenericAttribute']['name'], $varlist))
        $varlist[] = $gv['GenericAttribute']['name'];
    }
  }

  foreach($varlist as $j=>$var) {
    if($j != 0)
      printf("                ");
    printf('(:name "%s" :aggregators (sum))', $var);
    if($j != sizeof($varlist) - 1)
      printf("\n");
  }
  printf(")\n");

  // ---- constants ----
  printf("    :constants (");
  if(isset($generic_constants[$ge['GenericEntity']['id']])) {
    foreach($generic_constants[$ge['GenericEntity']['id']] as $i=>$gc) {
      if($i != 0)
        printf("                ");
      printf('(:name "%s" :lower-bound %s :upper-bound %s)', $gc['GenericAttribute']['name'], 
             $gc['GenericAttribute']['value'], $gc['GenericAttribute']['value']);
      if($i != sizeof($generic_constants[$gc['GenericEntity']['id']]) - 1)
        printf("\n");
    }    
  }
  printf("))");
  if($l != sizeof($generic_entities) -1)
    printf("\n");
}
   ?>)

  ;; ---- processes ----
  :process-list
  (<?
foreach($generic_processes as $i=>$gp) {
  if($i!=0)
    printf("   ");
  printf('(:name "%s"', $gp['GenericProcess']['name']);
  printf("\n    :equations (");
  foreach($generic_equation_list[$gp['GenericProcess']['id']] as $j=>$ge) {
    if($j!=0)
      printf("                ");
    $eid = $ge['GenericProcessArgument']['generic_entity_id'];
    $entity = $generic_entity_list[$eid];
    $var = sprintf('x%s', $ge['GenericProcessArgument']['id']);
    $attr = $ge['GenericAttribute']['name'];
    $rhs = trim($ge['GenericEquation']['right_hand_side']);

    // convert to postfix
    $rhs_str = $this->Math->toLisp($rhs, $gp['GenericProcessAttribute'],
                                   $concrete_process_attributes);

    if($ge['GenericEquation']['is_algebraic'] == 1)
      printf('(ALG ');
    else
      printf('(ODE ');
    printf(':variable "%s.%s" :rhs %s)', $var, $attr, $rhs_str);
    if($j != sizeof($generic_equation_list[$gp['GenericProcess']['id']]) - 1)
      printf("\n");
  }
  printf(")\n");
  // ---- conditions ----
  printf("    :conditions (");
  if(sizeof($gp['GenericCondition']) > 1)
    printf("(and ");
  foreach($gp['GenericCondition'] as $k=>$gc) {
    if($k!=0)
      printf("                      ");
    // convert the condition to postfix notation
    $val = trim($gc['value']);   
    
    $val_str = $this->Math->toLisp($val, $gp['GenericProcessAttribute'], 
                                   $concrete_process_attributes);

    printf("%s", $val_str);
    if($k != sizeof($gp['GenericCondition']) - 1)
      printf("\n");
  }
  if(sizeof($gp['GenericCondition']) > 1)
    printf(")");
  printf(")\n");

  // ---- entity roles ----
  printf("    :entity-roles (");
  foreach($gp['GenericProcessArgument'] as $l=>$ga) {
    if($l!=0)
      print("                   ");
    printf('(:name "x%s" :types ("%s"))', $ga['id'], $generic_entity_list[$ga['generic_entity_id']]);
    if($l != sizeof($gp['GenericProcessArgument']) - 1)
      printf("\n");
  }
  printf("))");
  if($i != sizeof($generic_processes) - 1)
    printf("\n");
}
 ?>)

  ;; ---- constraints ----
  :constraint-list
  (<?
foreach($generic_processes as $i=>$gp) {
  if($i != 0)
    printf("   ");
  printf('(:name req-%d :type exactly-one :items ((:gprocess "%s")))', $i, $gp['GenericProcess']['name']);
  if($i != sizeof($generic_processes) -1)
    printf("\n");
}
?>))