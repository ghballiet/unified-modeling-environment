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
    $rhs = $ge['GenericEquation']['right_hand_side'];
    $rhs = str_replace('?', '', $rhs);

    // loop through process attributes, replacing with values
    // first do concrete process attributes, then generic process attributes

    foreach($concrete_process_attributes as $cpa) {
      $name = $cpa['ConcreteProcessAttribute']['name'];
      $value = $cpa['ConcreteProcessAttribute']['value'];
      $rhs = str_replace($name, $value, $rhs);
    }

    foreach($gp['GenericProcessAttribute'] as $gpa) {
        $rhs = str_replace($gpa['name'], $gpa['value'], $rhs);
    }
    
    // convert equations to postfix notation
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
    $val = $gc['value'];
    $val_str = '';
    $vars = array();
    $val = str_replace('?', '', $val);
    $op_regex = '/[>=|<=|<|>|=]/';
    $operand = null;
    preg_match($op_regex, $val, $operand);
    $operand = $operand[0];
    $tokens = preg_split($op_regex, $val);
    foreach($tokens as $m=>$t)
      $tokens[$m] = trim($t);
    $left = $tokens[0];
    $lstr = '';
    $right = $tokens[1];
    $rstr = '';
    $ltokens = split(' ', $left);
    $rtokens = split(' ', $right);

    // parse left hand side
    if(sizeof($ltokens) == 1) {
      if(!is_numeric($left))
        $lstr = sprintf('"%s"', $left);
      else
        $lstr = $left;
    } else {
      for($n=0; $n<=sizeof($ltokens); $n+=2) {
        if($n==2) {
          $first = $ltokens[$n-2];
          $op = $ltokens[$n-1];
          $second = $ltokens[$n];
          if(!is_numeric($first))
            $first = sprintf('"%s"', $first);
          if(!is_numeric($second))
            $second = sprintf('"%s"', $second);
          $lstr = sprintf('(%s %s %s)', $op, $first, $second);
        } else {
          if(!array_key_exists($n-1, $ltokens))
            continue;
          $arg = $ltokens[$n];
          $op = $ltokens[$n-1];
          if(!is_numeric($arg))
            $arg = sprintf('"%s"', $arg);
          $lstr = sprintf('(%s %s %s)', $op, $lstr, $arg);
        }      
      }
    }

    // parse right hand side
    if(sizeof($rtokens) == 1) {
      if(!is_numeric($right))
        $rstr = sprintf('"%s"', $right);
      else
        $rstr = $right;
    } else {
      for($n=0; $n<=sizeof($rtokens); $n+=2) {
        if($n==2) {
          $first = $rtokens[$n-2];
          $op = $rtokens[$n-1];
          $second = $rtokens[$n];
          if(!is_numeric($first))
            $first = sprintf('"%s"', $first);
          if(!is_numeric($second))
            $second = sprintf('"%s"', $second);
          $rstr = sprintf('(%s %s %s)', $op, $first, $second);
        } else {
          if(!array_key_exists($n-1, $rtokens))
            continue;
          $arg = $rtokens[$n];
          $op = $rtokens[$n-1];
          if(!is_numeric($arg))
            $arg = sprintf('"%s"', $arg);
          $rstr = sprintf('(%s %s %s)', $op, $lstr, $arg);
        }      
      }      
    }
    
    
    $val_str = sprintf("(%s %s %s)", $operand, $lstr, $rstr);
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