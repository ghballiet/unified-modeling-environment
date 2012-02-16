<?
printf("// NAME: %s\n", $model['UnifiedModel']['name']);
printf("// DESC: %s\n\n", $model['UnifiedModel']['description']);

printf("// entities\n");

// concrete entities
foreach($concrete_entities as $ce) {
  printf("var x%d = {", $ce['ConcreteEntity']['id']);
  printf("'id': %d, 'entity_name': '%s', ", $ce['ConcreteEntity']['id'], $ce['ConcreteEntity']['name']);
  foreach($ce['ConcreteAttribute'] as $ca) {
    printf("'%s': %s, ", $ca['name'], $ca['value']);
  }
  printf("};\n");
}

// process attributes
printf("\n// process attributes\n");
foreach($concrete_processes as $cp) {
  foreach($cp['ConcreteProcessAttribute'] as $cpa) {
    printf("var %s = %s;\n", $cpa['name'], $cpa['value']);
  }
}

// exogenous values
printf("\n// exogenous values\n");
foreach($exogenous_values as $e) {
  printf("x%d['%s'] = %s;\n", $e['ConcreteAttribute']['concrete_entity_id'], $e['ConcreteAttribute']['name'],
         $e['ExogenousValue']['value']);
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

printf("\n//add to variables list\n");

// add variables
printf("var variables={};\n");
foreach($concrete_entities as $ce)
  printf("variables.x%d = x%d;\n", $ce['ConcreteEntity']['id'], $ce['ConcreteEntity']['id']);
?>