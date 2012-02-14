<?
echo $this->Html->tag('h1', 'Please log in to continue.');
echo $this->Form->create('User', array(
  'action'=>'login', 'inputDefaults'=>array('div'=>array('required'=>'true'))));
echo $this->Form->input('email', array('type'=>'email', 'placeholder'=>'john@email.com', 'spellcheck'=>'false'));
echo $this->Form->input('password', array('placeholder'=>'password'));
echo $this->Form->submit('Log In', array('div'=>array('data-role'=>'fieldcontain')));
?>