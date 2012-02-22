<?
printf("// NAME: %s\n", $model['UnifiedModel']['name']);
printf("// AUTH: %s (%s)\n", $user['User']['name'], $user['User']['email']);
printf("// DESC: %s\n\n", $model['UnifiedModel']['description']);

printf("var values = {};\n");

printf("// entities\n");

// concrete entities
printf("values[0] = {};\n");
foreach($concrete_entities as $ce) {
  foreach($ce['ConcreteAttribute'] as $ca) {
    printf("values[0]['%s.%s'] = %s;\n", $ce['ConcreteEntity']['name'], $ca['name'], $ca['value']);
  }
}

// process attributes
printf("\n// process attributes\n");
foreach($concrete_processes as $cp) {
  foreach($cp['ConcreteProcessAttribute'] as $cpa) {
    printf("var %s = %s;\n", $cpa['name'], $cpa['value']);
  }
}

// exogenous data
printf("\n// exogenous data\n");
$ex = $exogenous_data['ExogenousValue'];
$lines = explode("\n", $ex['value']);
$arr = array();
$arr['data'] = array();
foreach($lines as $i => $line) {
  $line = str_replace("\r", '', $line);
  $line = preg_replace('/\s\s+/', ' ', $line);
  if($line == '') 
    continue;
  $tokens = split(' ', $line);
  if($i == 0) {
    $arr['keys'] = $tokens;
  } else {
      $arr['data'][] = $tokens;
  }
}

foreach($arr['data'] as $h=>$row) {
  $i = $h+1;
  printf("values[%d] = {};\n", $i);
  foreach($concrete_entities as $ce) {
    foreach($ce['ConcreteAttribute'] as $ca)
      printf("values[%d]['%s.%s'] = %s;\n", $i, $ce['ConcreteEntity']['name'], $ca['name'], $ca['value']);
  }

  foreach($row as $j=>$val) {
    $key = $arr['keys'][$j];
    $split = split('\.', $key);
    $entity = $split[0];
    $attr = $split[1];
    $val = floatval($val);
    printf("values[%d]['%s.%s'] = %s;\n", $i, $entity, $attr, $val);
  }
}


printf("\n// process equations\n");
printf("lhs_variables = [];\n");
// concrete equations
foreach($concrete_equations as $cq) {
  // build terms
  $rhs = $cq['ConcreteEquation']['right_hand_side'];
  for($i=0; $i<sizeof($arr['data']); $i++) {
    $h = $i + 1;
    $entity_id = $cq['ConcreteAttribute']['concrete_entity_id'];
    $entity_name = $concrete_entity_list[$entity_id];
    $attr_name = $cq['ConcreteAttribute']['name'];
    $rhs = preg_replace('/\s\s+/', ' ', $rhs);
    $rhs = str_replace('?','', $rhs);
    $tokens = explode(' ', $rhs);
    $parsedTokens = array();
    foreach($tokens as $j=>$token) {
      $token = preg_replace('/(\w+)\.(\w+)/', "values[%d]['$1.$2']", $token);
      $parsedTokens[$j] = sprintf($token, $h);
    }
    $newRhs = join(' ', $parsedTokens);
    printf("values[%d]['%s.%s'] += %s;\n", $h, $entity_name, $attr_name, $newRhs);
  }
  printf("if($.inArray('%s.%s', lhs_variables) == -1) lhs_variables.push('%s.%s');\n",
         $entity_name, $attr_name, $entity_name, $attr_name);
}
?>