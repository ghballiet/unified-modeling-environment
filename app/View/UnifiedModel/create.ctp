<?
echo $this->Html->tag('h1', 'Create Model');
echo $this->Form->create('UnifiedModel', array(
  'inputDefaults'=>array('div'=>array('required'=>'true'))));
echo $this->Form->input('user_id', array('type'=>'hidden', 'value'=>AuthComponent::user('id')));
echo $this->Form->input('name', array('placeholder'=>'The name of the model.'));
echo $this->Form->input('description', array('placeholder'=>'A brief description of the model.'));
echo $this->Form->submit('Create Model');
?>