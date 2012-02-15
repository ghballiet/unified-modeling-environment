<?
class ExogenousValue extends AppModel {
  public $name = 'ExogenousValue';
  public $belongsTo = array('ConcreteAttribute', 'UnifiedModel');
}
?>