<?
class ConcreteProcessArgument extends AppModel {
  public $name = 'ConcreteProcessArgument';
  public $belongsTo = array('ConcreteProcess', 'ConcreteEntity');
}
?>