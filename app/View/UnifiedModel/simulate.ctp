<?
printf("// NAME: %s\n", $model['UnifiedModel']['name']);
printf("// AUTH: %s (%s)\n", $user['User']['name'], $user['User']['email']);
printf("// DESC: %s\n\n", $model['UnifiedModel']['description']);

printf("// entities\n");

// concrete entities
foreach($concrete_entities as $ce) {
  printf("var %s = {", $ce['ConcreteEntity']['name']);
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

// exogenous data
printf("\n// exogenous data\n");
$ex = $exogenous_data['ExogenousValue'];
$lines = explode("\n", $ex['value']);
$arr = array();
$arr['data'] = array();
foreach($lines as $i => $line) {
  $line = str_replace("\r", '', $line);
  $line = preg_replace('/\s\s+/', ' ', $line);
  $tokens = split(' ', $line);
  if($i == 0)
    $arr['keys'] = $tokens;
  else
    $arr['data'][] = $tokens;
}
printf("var values = {};\n");
foreach($arr['data'] as $i=>$row) {
  printf("values[%d] = [];\n", $i);
  foreach($row as $j=>$val) {
    $key = $arr['keys'][$j];
    $split = split('\.', $key);
    $entity = $split[0];
    $attr = $split[1];
    $val = floatval($val);
    $r = array('entity'=>$entity, 'attribute'=>$attr, 'value'=>$val);
    printf("values[%d].push(%s);\n", $i, json_encode($r));
  }
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
    $token = preg_replace('/^(\d+)\.(\w+)$/i', "$1.$2", $token);
    $parsedTokens[$i] = $token;
  }
  $newRhs = join(' ', $parsedTokens);

  $entity_id = $cq['ConcreteAttribute']['concrete_entity_id'];
  $name = $concrete_entity_list[$entity_id];

  printf("%s.%s += %s;\n", $name, $cq['ConcreteAttribute']['name'], $newRhs);
}

printf("\n//add to variables list\n");

// add variables
printf("var variables={};\n");
foreach($concrete_entities as $ce)
  printf("variables.x%d = %s;\n", $ce['ConcreteEntity']['id'], $ce['ConcreteEntity']['name']);
?>