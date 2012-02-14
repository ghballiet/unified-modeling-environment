<?
echo $this->Html->tag('h1', 'Create a New Account');
echo $this->Form->create('User', array('inputDefaults'=>array(
  'required'=>'true', 'div'=>array('data-role'=>'fieldcontain'))));
echo $this->Form->input('name', array('placeholder'=>'Please enter your name.'));
echo $this->Form->input('email', array('type'=>'email', 'placeholder'=>'john@email.com'));
echo $this->Form->input('emailConfirm', array('label'=>'Confirm Email', 'type'=>'email', 'placeholder'=>'john@email.com'));
echo $this->Form->input('password', array('placeholder'=>'Please enter a password.'));
echo $this->Form->input('passwordConfirm', array('label'=>'Confirm Password', 'type'=>'password', 'placeholder' => 'Please confirm your password.'));
echo $this->Form->submit('Register');
?>