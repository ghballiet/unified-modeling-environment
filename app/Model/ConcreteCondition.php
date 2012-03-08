<?
class ConcreteCondition extends AppModel {
  public $name = 'ConcreteCondition';
  public $belongsTo = array('ConcreteProcess', 'GenericCondition');
}
?>