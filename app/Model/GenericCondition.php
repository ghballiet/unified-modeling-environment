<?
class GenericCondition extends AppModel {
  public $name = 'GenericCondition';
  public $belongsTo = 'GenericProcess';
  public $hasMany = 'ConcreteCondition';
}
?>