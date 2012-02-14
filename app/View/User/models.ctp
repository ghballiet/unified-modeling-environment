<?
echo $this->Html->link('Add Model', array('controller'=>'unified_models', 'action'=>'create'), array('class'=>'btnAdd'));
echo $this->Html->tag('h1', 'Model Selection');
?>
<div class="models">
<?
foreach($models as $model) {
?>
<a class="model" href="<? echo $this->Html->url(array('controller'=>'models', 'action'=>'view', $model['UnifiedModel']['id']))?>">
<?
echo $this->Html->div('name', $model['UnifiedModel']['name']);
echo $this->Html->para('description', $model['UnifiedModel']['description']);
?>
</a>
<?
}
?>
</div>