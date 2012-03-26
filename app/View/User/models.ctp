<?
echo $this->Html->link('Add Model', array('controller'=>'unified_models', 'action'=>'create'), array('class'=>'btnAdd'));
echo $this->Html->tag('h1', 'Model Selection');
if(sizeof($models) < 20) {
?>
<div class="models">
<?
  foreach($models as $model) {
?>
<a class="model" href="<? echo $this->Html->url(array('controller'=>'models', 'action'=>'view', $model['UnifiedModel']['id']))?>">
<?
  echo $this->Html->div('name', $model['UnifiedModel']['name']);
  if($users)
    printf('<div class="owner">%s</div>', $users[$model['UnifiedModel']['user_id']]);
  echo $this->Html->para('description', $model['UnifiedModel']['description']);
?>
</a>
<?
  }
  echo '</div>';
} else {
?>
<table>
<?
    if($users)
      echo $this->Html->tableHeaders(array('ID', 'Owner', 'Name', 'Description'));
    else
      echo $this->Html->tableHeaders(array('ID', 'Name', 'Description'));

  foreach($models as $model) {
    $name = $model['UnifiedModel']['name'];
    $id = $model['UnifiedModel']['id'];
    $description = $model['UnifiedModel']['description'];
    $user_id = $model['UnifiedModel']['user_id'];
    $arr = array();
    $arr[] = $id;
    if($users)
      $arr[] = $users[$user_id];
    $arr[] = $this->Html->link($name, array('controller'=>'models','action'=>'view', $id));
    $arr[] = $description;
    echo $this->Html->tableCells($arr);
  }
  echo '</table>';
}
?>
