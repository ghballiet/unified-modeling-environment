<?
class GenericProcess extends AppModel {
  public $name = 'GenericProcess';
  public $belongsTo = array('UnifiedModel');
  public $hasMany = array('GenericEquation', 'GenericProcessArgument',
                          'GenericProcessAttribute', 'ConcreteProcess',
                          'GenericCondition');
}
?>