<script type="text/javascript">
// pretty much all the data, as JSON
var model = <? print json_encode($model); ?>;
var generic_entities = <? print json_encode($generic_entities); ?>;
var generic_attributes = <? print json_encode($generic_attributes); ?>;
var generic_entity_list = <? print json_encode($generic_entity_list); ?>;
var generic_processes = <? print json_encode($generic_processes); ?>;
var generic_process_list = <? print json_encode($generic_process_list); ?>;
var generic_equations = <? print json_encode($generic_equations); ?>;
var generic_process_arguments = <? print json_encode($generic_process_arguments); ?>;
var concrete_entities = <? print json_encode($concrete_entities); ?>;
var concrete_entity_list = <? print json_encode($concrete_entity_list); ?>;
var concrete_processes = <? print json_encode($concrete_processes); ?>;
var concrete_equations = <? print json_encode($concrete_equations); ?>;
var concrete_process_arguments = <? print json_encode($concrete_process_arguments); ?>;
var concrete_process_argument_list = <? print json_encode($concrete_process_argument_list); ?>;
var exogenous_values = <? print json_encode($exogenous_values); ?>;

// empirical data
var empirical_data = {};
<?
printf("empirical_data[0] = {};\n");
// concrete entities
foreach($concrete_entities as $ce) {
  foreach($ce['ConcreteAttribute'] as $ca) {
    printf("empirical_data[0]['%s.%s'] = %s;\n", $ce['ConcreteEntity']['name'], $ca['name'], $ca['value']);
  }
}
// empirical data
$ed = $empirical_data['EmpiricalObservation'];
$lines = explode("\n", $ed['value']);
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

foreach($arr['data'] as $h=>$row) {
  $i = $h+1;
  printf("empirical_data[%d] = {};\n", $i);
  foreach($concrete_entities as $ce) {
    foreach($ce['ConcreteAttribute'] as $ca)
      printf("empirical_data[%d]['%s.%s'] = %s;\n", $i, $ce['ConcreteEntity']['name'], $ca['name'], 
             $ca['value']);
  }

  foreach($row as $j=>$val) {
    $key = $arr['keys'][$j];
    $split = split('\.', $key);
    $entity = $split[0];
    $attr = $split[1];
    $val = floatval($val);
    printf("empirical_data[%d]['%s.%s'] = %s;\n", $i, $entity, $attr, $val);
  }
}
?>
</script>

<div id="simulating-msg" class="reveal-modal">
<a class="close-reveal-modal">&#215;</a>
<h1>Simulating...</h1>
<? echo $this->Html->image('ajax_loader.gif'); ?>
<pre></pre>
</div>

<?
echo $this->Html->link('Delete Model', '#', array('data-delete-url'=>$this->Html->url(array(
  'controller'=>'unified_models', 'action'=>'delete', $model['UnifiedModel']['id'])), 
  'class'=>'deleteModel'));
echo $this->Html->tag('h1', $model['UnifiedModel']['name']);

// add-generic-entity
printf('<div id="add-generic-entity" class="reveal-modal">');
printf('<a href="#" class="close-reveal-modal">&#215;</a>');
echo $this->Html->tag('h1', 'Add Generic Entity');
echo $this->Form->create('GenericEntity', array('controller'=>'GenericEntity', 'action'=>'create', 'inputDefaults'=>array(
  'required'=>'true')));
echo $this->Form->input('name', array('placeholder'=>'The name of the entity.'));
echo $this->Form->input('unified_model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
echo $this->Form->end('Add Entity');
printf('</div>');

// add-generic-process
printf('<div id="add-generic-process" class="reveal-modal">');
printf('<a href="#" class="close-reveal-modal">&#215;</a>');
echo $this->Html->tag('h1', 'Add Generic Process');
echo $this->Form->create('GenericProcess', array('controller'=>'GenericProcess', 'action'=>'create', 'inputDefaults'=>array(
  'required'=>'true')));
echo $this->Form->input('name', array('placeholder'=>'The name of the process.'));
echo $this->Form->input('num_arguments', array('options'=>range(1,20), 'label'=>'# of Arguments'));
echo $this->Form->input('argument-1', array('label'=>'Argument 1', 'options'=>$generic_entity_list));
foreach(range(2, 20) as $i) {
  echo $this->Form->input("argument-$i", array('label'=>"Argument $i", 'options'=>$generic_entity_list,
                                               'div'=>array('class'=>'input select hidden', 'id'=>"arg_$i")));
}
echo $this->Form->input('unified_model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
echo $this->Form->end('Add Process');
printf('</div>');

// add-concrete-entity
printf('<div id="add-concrete-entity" class="reveal-modal">');
printf('<a href="#" class="close-reveal-modal">&#215;</a>');
echo $this->Html->tag('h1', 'Add Concrete Entity');
echo $this->Form->create('ConcreteEntity', array('controller'=>'ConcreteEntity', 'action'=>'create', 'inputDefaults'=>array(
  'required'=>'true')));
echo $this->Form->input('name', array('placeholder'=>'The name of the entity.'));
echo $this->Form->input('generic_entity_id', array('options'=>$generic_entity_list));
echo $this->Form->input('unified_model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
echo $this->Form->end('Add Entity');
printf('</div>');

// add-concrete-process
printf('<div id="add-concrete-process" class="reveal-modal">');
printf('<a href="#" class="close-reveal-modal">&#215;</a>');
echo $this->Html->tag('h1', 'Add Concrete Process');
echo $this->Form->create('ConcreteProcess', array('controller'=>'concrete_processes', 'action'=>'create', 'inputDefaults'=>array(
  'required'=>'true')));
echo $this->Form->input('name', array('placeholder'=>'The name of the process.'));
echo $this->Form->input('generic_process_id', array('options'=>$generic_process_list));
echo $this->Form->input('num_arguments', array('type'=>'hidden'));
echo $this->Html->tag('div', '', array('id'=>'ConcreteProcessArguments'));
echo $this->Form->input('unified_model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
echo $this->Form->end('Add Process');
printf('</div>');
?>

<div class="left">
  <div class="generic">
    <div class="header">
      <h2>Generic</h2>
      <div class="actions">
        <a href="#" class="btn" data-reveal-id="add-generic-entity">&plus;Entity</a>
        <a href="#" class="btn" data-reveal-id="add-generic-process">&plus;Process</a>
      </div>
      <div class="clearfix"></div>
    </div>
    <div class="content">
      <div class="entities">
<?
foreach($generic_entities as $e) {
  printf('<div class="generic-entity" id="generic-entity-%s">', $e['GenericEntity']['id']);
  echo $this->Html->link('×', array('controller'=>'generic_entities', 'action'=>'delete', 
                                    $e['GenericEntity']['id'], $model['UnifiedModel']['id']),
                         array('class'=>'btnDelete'));
  printf('<span class="type">entity</span> <span class="name">%s</span>(?x) {<br>',
         $e['GenericEntity']['name']);
  foreach($e['GenericAttribute'] as $a) {
    printf('<div class="generic-attribute" id="generic-attribute-%s">', $a['id']);
    echo $this->Html->link('×', array('controller'=>'generic_attributes', 'action'=>'delete', $a['id'],
      $model['UnifiedModel']['id']), array('class'=>'btnDelete'));
    printf('.<span class="name">%s</span> = <span class="value">[%s, %s]</span>;<br>', $a['name'],
           $a['lower_bound'], $a['upper_bound']);
    printf('</div>');
  }

  // ---- generic attributes ----  
  printf('<div id="add-generic-attribute-%s" class="reveal-modal">', $e['GenericEntity']['id']);
  printf('<a href="#" class="close-reveal-modal">&#215;</a>');
  echo $this->Html->tag('h1', 'Add Generic Attribute');
  echo $this->Form->create('GenericAttribute', array('controller'=>'GenericAttribute', 'action'=>'create', 
                                                     'inputDefaults'=>array(
                                                       'required'=>'true')));
  echo $this->Form->input('name', array('placeholder'=>'The name of the attribute.'));
  // echo $this->Form->input('value', array('placeholder'=>'The default value of the attribute.'));
  echo $this->Form->input('lower_bound', array('placeholder'=>'The lower bound of the attribute.'));
  echo $this->Form->input('upper_bound', array('placeholder'=>'The upper bound of the attribute.'));
  echo $this->Form->input('generic_entity_id', array('type'=>'hidden', 'value'=>$e['GenericEntity']['id']));
  echo $this->Form->input('generic_entity', array('readonly'=>'true', 'value'=>$e['GenericEntity']['name']));
  echo $this->Form->input('unified_model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
  echo $this->Form->end('Add Attribute');
  printf('</div>');

  printf('<a href="#" class="btn" data-reveal-id="add-generic-attribute-%s">&plus;Attribute</a><br>',
         $e['GenericEntity']['id']);
  printf('}');
  printf('</div>');
}
?>
      </div>
      <div class="processes">
<?
// processes start here
foreach($generic_processes as $p) {
  printf('<div class="generic-process" id="generic-process-%s">', $p['GenericProcess']['id']);
  echo $this->Html->link('×', array('controller'=>'generic_processes', 'action'=>'delete', 
                                    $p['GenericProcess']['id'],
                                    $model['UnifiedModel']['id']), array('class'=>'btnDelete'));      
  printf('<span class="type">process</span> <span class="name">%s</span>(', $p['GenericProcess']['name']);
  
  $args = array();
  // print out arguments
  foreach($p['GenericProcessArgument'] as $a) {
    $entity = $generic_entity_list[$a['generic_entity_id']];
    $args[] = sprintf('<span class="arg">%s</span> ?x%s', $entity, $a['id']);
  }

  printf('%s) {<br>', join($args, ', '));

  // process attribute stuff goes here
  foreach($p['GenericProcessAttribute'] as $a) {
    printf('<div class="generic-process-attribute" id="generic-process-attribute-%s">', $a['id']);
    echo $this->Html->link('×', array('controller'=>'generic_process_attributes', 'action'=>'delete', $a['id'],
      $model['UnifiedModel']['id']), array('class'=>'btnDelete'));
    printf('<span class="name">%s</span> = <span class="value">%s</span>;<br>', $a['name'], $a['value']);
    printf('</div>');
  }
  printf('<a href="#" class="btn" data-reveal-id="add-generic-process-attribute-%s">&plus;Attribute</a><br>', $p['GenericProcess']['id']);
  printf('<div id="add-generic-process-attribute-%s" class="reveal-modal">', $p['GenericProcess']['id']);
  echo $this->Html->tag('h1', 'Add Generic Process Attribute');
  echo $this->Form->create('GenericProcessAttribute', array('controller'=>'generic_process_attributes', 'action'=>'create', 'inputDefaults'=>array(
    'required'=>'true')));
  echo $this->Form->input('name', array('placeholder'=>'The descriptive name of the attribute.'));
  echo $this->Form->input('value', array('placeholder'=>'The value of the attribute.'));
  echo $this->Form->input('generic_process_id', array('type'=>'hidden', 'value'=>$p['GenericProcess']['id']));
  echo $this->Form->input('model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
  echo $this->Form->end('Add Attribute');
  printf('</div>');
  
  // equation stuff goes here
  printf('<div id="add-generic-equation-%s" class="reveal-modal">', $p['GenericProcess']['id']);
  echo $this->Html->tag('h1', 'Add Generic Equation');
  echo $this->Form->create('GenericEquation', array('controller'=>'generic_equations', 'action'=>'create'));
  echo $this->Form->input('is_algebraic', array('label'=>'Algebraic Equation'));
  $opts = $generic_process_arguments[$p['GenericProcess']['id']];
  echo $this->Form->input('generic_attribute_id', array('label'=>'Left-Hand Side', 'options'=>$opts));
  echo $this->Form->input('right_hand_side', array('placeholder'=>'The right hand side of the equation.'));
  echo $this->Form->input('generic_process_id', array('type'=>'hidden', 'value'=>$p['GenericProcess']['id']));
  echo $this->Form->input('model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
  echo $this->Form->end('Add Equation');
  printf('</div>');
  
  foreach($generic_equations[$p['GenericProcess']['id']] as $q) {
    printf('<div class="generic-equation" id="generic-equation-%s">', $q['GenericEquation']['id']);
    echo $this->Html->link('×', array('controller'=>'generic_equations', 'action'=>'delete', $q['GenericEquation']['id'],
      $model['UnifiedModel']['id']), array('class'=>'btnDelete'));
    if($q['GenericEquation']['is_algebraic'] == 1) {
      // algebraic eq
      printf('<span class="name">?x%s.%s</span>', $q['GenericProcessArgument']['id'], $q['GenericAttribute']['name']);
    } else {
      // diff eq
      printf('<span class="name">d[?x%s.%s]</span>', $q['GenericProcessArgument']['id'], $q['GenericAttribute']['name']);
    }
    printf(' = <span class="value">%s</span>;', $q['GenericEquation']['right_hand_side']);
    printf('</div>');
  }
  printf('<a href="#" class="btn" data-reveal-id="add-generic-equation-%s">&plus;Equation</a><br>', $p['GenericProcess']['id']);
  
  // ---- generic conditions ----
  printf('<div id="add-generic-condition-%s" class="reveal-modal">', $p['GenericProcess']['id']);
  echo $this->Html->tag('h1', 'Add Generic Process Condition');
  echo $this->Form->create('GenericCondition', array('controller'=>'generic_conditions', 'action'=>'create'),
                           array('inputDefaults'=>array('required'=>'true')));
  echo $this->Form->input('value', array('placeholder'=>'True for this process to execute.'));
  echo $this->Form->input('generic_process_id', array('type'=>'hidden', 'value'=>$p['GenericProcess']['id']));
  echo $this->Form->input('unified_model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
  echo $this->Form->end('Add Condition');
  printf('</div>');


  printf('<a href="#" class="btn" data-reveal-id="add-generic-condition-%s">&plus;Condition</a><br>', $p['GenericProcess']['id']);
  
  // end of process
  printf('}');
  if(sizeof($p['GenericCondition']) > 0) {
    printf(' if(');
    foreach($p['GenericCondition'] as $i=>$gc) {
      printf('<span class="generic-condition condition" id="generic-condition-%s">%s</span>', $gc['id'], $gc['value']);
      if(sizeof($p['GenericCondition']) > 1 && $i != sizeof($p['GenericCondition']) - 1)
        printf(' and ');
    }    
    printf(')');
  }
  printf('</div>');
}
?>
      </div>
    </div>
  </div>
</div>
<div class="right">
  <div class="header">
    <h2>Simulation</h2>
  </div>
  <div class="content">
    <div id="exogenous-values" class="reveal-modal">
<?
$ex_text = '';
echo $this->Html->tag('h1', 'Edit Data File');
if($exogenous_values != null) {
  $ex_text = $exogenous_values['ExogenousValue']['value'];
  $ex_step = $exogenous_values['ExogenousValue']['step_size'];
}
echo $this->Form->create('ExogenousValue', array('controller'=>'exogenous_values', 'action'=>'edit'));
echo $this->Form->input('unified_model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
echo $this->Form->input('step_size', array('type'=>'number', 'min'=>'1', 'max'=>'100',
                                           'placeholder'=>'The step size, from 1 to 100.', 'value'=>$ex_step));
echo $this->Form->input('value', array('value'=>$ex_text, 'placeholder'=>'Type or copy/paste the data here.'));
echo $this->Form->end('Save Data');
?>
    </div>
    <div id="empirical-data" class="reveal-modal">
<?
$eo_text = '';
echo $this->Html->tag('h1', 'Edit Empirical Data');
if($empirical_data != null) {
  $eo_text = $empirical_data['EmpiricalObservation']['value'];
}
echo $this->Form->create('EmpiricalObservation', array('controller'=>'empirical_observations',
                                                       'action'=>'edit'));
echo $this->Form->input('unified_model_id', array('type'=>'hidden', 'value'=>$model['UnifiedModel']['id']));
echo $this->Form->input('value', array('value'=>$eo_text));
echo $this->Form->end('Save Data');
?>
    </div>
    <a href="#" data-reveal-id="exogenous-values" class="btn">Edit Data File</a>
    <a href="#" class="btn" id="btnSimulate">Simulate</a>
<?
$url = $this->Html->url(array('controller'=>'unified_models', 'action'=>'simulate',
                              $model['UnifiedModel']['id']));
printf('<input type="hidden" id="data-url" value="%s">', $url);
?>
    <div id="data-selection">
    </div>
    <div id="google-chart">
      <script type="text/javascript">
        google.load('visualization', '1', { packages: ['corechart']});
      </script>
    </div>
    <!-- 
    <div id="simulation-data">
      <table>
        <thead><tr><th>Time</th><th>Attribute</th><th>Value</th></tr></thead>
        <tbody></tbody>
      </table>
    </div>  
    -->
  </div>
</div>
<div class="clearfix"></div>
