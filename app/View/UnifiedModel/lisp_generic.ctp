<?
// entities
printf('  :entity-list(');
foreach($entities as $e) {
  printf("\n    ");
  printf('(:type "%s" ', $e['GenericEntity']['name']);
  printf('(:variables ');
  foreach($e['GenericAttribute'] as $a) {
    printf('(:name "%s" :aggregators (sum))', $a['name']);
  }
  printf(')');
  printf(")");
}
printf("\n  )");
?>