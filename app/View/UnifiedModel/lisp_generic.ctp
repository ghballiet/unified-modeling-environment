<pre>
(in-package :scipm)

(create-generic-library data-<? echo $model['UnifiedModel']['id']; ?>

  ;; ---- entities ----
  :entity-list
  (<?
foreach($generic_entities as $ge) {
  printf("(:type \"%s\"\n", $ge['GenericEntity']['name']);
  
  
  // ---- variables ----
  printf("    :variables (");
  foreach($generic_variables[$ge['GenericEntity']['id']] as $i=>$gv) {
    if($i != 0)
      printf("                ");
    printf('(:name "%s" :aggregators (sum))', $gv['GenericAttribute']['name']);
    if($i != sizeof($generic_variables[$ge['GenericEntity']['id']]) - 1)
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
  foreach($generic_equation_list[$gp['GenericProcess']['id']] as $ge) {
    $eid = $ge['GenericProcessArgument']['generic_entity_id'];
    // add the equations here
  }
  printf("))");
  if($i != sizeof($generic_processes) - 1)
    printf("\n");
}
?>)

 ;; ---- constraints ----
)
</pre>