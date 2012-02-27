<pre>
(in-package :scipm)

(create-generic-library data-<? echo $model['UnifiedModel']['id']; ?>

  ;; ---- entities ----
  :entity-list
  (<?
foreach($generic_entities as $ge) {
  printf("(:type \"%s\"\n", $ge['GenericEntity']['name']);
  
  
  // ---- variables ----
  $varlist = array();
  printf("    :variables (");
  foreach($generic_variables[$ge['GenericEntity']['id']] as $i=>$gv) {
    if(!in_array($gv['GenericAttribute']['name'], $varlist))
      $varlist[] = $gv['GenericAttribute']['name'];
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
  foreach($generic_constants[$ge['GenericEntity']['id']] as $i=>$gc) {
    if($i != 0)
      printf("                ");
    printf('(:name "%s" :lower-bound %s :upper-bound %s)', $gc['GenericAttribute']['name'], 
           $gc['GenericAttribute']['value'], $gc['GenericAttribute']['value']);
    if($i != sizeof($generic_constants[$gc['GenericEntity']['id']]) - 1)
      printf("\n");
  }
  printf("))");
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
    $rhs = $ge['GenericEquation']['right_hand_side'];
    $rhs = str_replace('?', '', $rhs);
    $tokens = split(' ', $rhs);
    $rhs_str = '';
    $vars = array();
    for($k=0; $k<sizeof($tokens); $k+=2) {
      if($k==2) {
        $first_arg = $tokens[$k-2];
        $operand = $tokens[$k-1];
        $second_arg = $tokens[$k];
        if(!is_numeric($first_arg))
          $first_arg = sprintf('"%s"', $first_arg);
        if(!is_numeric($second_arg))
          $second_arg = sprintf('"%s"', $second_arg);
        $rhs_str = sprintf('(%s %s %s)', $operand, $first_arg, $second_arg);
      } else {
        if(!array_key_exists($k-1, $tokens))
          continue;
        $arg = $tokens[$k];
        $operand = $tokens[$k-1];
        if(!is_numeric($arg))
          $arg = sprintf('"%s"', $arg);
        $rhs_str = sprintf('(%s %s %s)', $operand, $rhs_str, $arg);
      }
    }
    printf('(ODE :variable "%s.%s" :rhs %s)', $var, $attr, $rhs_str);
    if($j != sizeof($generic_equation_list[$gp['GenericProcess']['id']]) - 1)
      printf("\n");
  }
  printf(")\n");
  printf("    :entity-roles (");
  foreach($gp['GenericProcessArgument'] as $l=>$ga) {
    if($l!=0)
      print("                   ");
    printf('(:name "x%s" :types ("%s"))', $ga['id'], $generic_entity_list[$ga['generic_entity_id']]);
    if($l != sizeof($gp['GenericProcessArgument']) - 1)
      printf("\n");
  }
  printf(")");
  if($i != sizeof($generic_processes) - 1)
    printf("\n");
}
?>)

 ;; ---- constraints ----
 (<?
foreach($generic_processes as $i=>$gp) {
  if($i != 0)
    printf("  ");
  printf('(:name req-%d :type exactly-one :items ((:gprocess "%s")))', $i, $gp['GenericProcess']['name']);
  if($i != sizeof($generic_processes) -1)
    printf("\n");
}
?>))
</pre>