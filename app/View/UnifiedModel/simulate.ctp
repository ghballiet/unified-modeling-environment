<?
printf("// NAME: %s\n", $model['UnifiedModel']['name']);
printf("// DESC: %s\n\n", $model['UnifiedModel']['description']);

printf("// entities\n");

// concrete entities
foreach($concrete_entities as $ce) {
  printf("var x%d = {", $ce['ConcreteEntity']['id']);
  foreach($ce['ConcreteAttribute'] as $ca) {
    printf("'%s': %s, ", $ca['name'], $ca['value']);
  }
  printf("};\n");
}

printf("\n// equations\n");

// concrete equations
foreach($concrete_equations as $cq) {
  // build terms
  $rhs = $cq['ConcreteEquation']['right_hand_side'];
  $tokens = explode(' ', $rhs);
  $parsedTokens = array();
  foreach($tokens as $i=>$token) {
    $token = str_replace('?', '', $token);
    $token = preg_replace('/^x(\d+)\.(\w+)$/i', "x$1.$2", $token);
    $parsedTokens[$i] = $token;
  }
  $newRhs = join(' ', $parsedTokens);

  printf("x%d.%s += %s;\n", $cq['ConcreteAttribute']['concrete_entity_id'],
         $cq['ConcreteAttribute']['name'], $newRhs);
}
?>