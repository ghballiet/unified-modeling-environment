<?
class ConcreteProcess extends AppModel {
  public $name = 'ConcreteProcess';
  public $belongsTo = array('UnifiedModel', 'GenericProcess');
  public $hasMany = array('ConcreteProcessArgument', 'ConcreteEquation', 'ConcreteProcessAttribute');
}
?>