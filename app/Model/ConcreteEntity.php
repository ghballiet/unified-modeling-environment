<?
class ConcreteEntity extends AppModel {
  public $name = 'ConcreteEntity';
  public $belongsTo = array('GenericEntity', 'UnifiedModel');
  public $hasMany = array('ConcreteAttribute', 'ConcreteProcessArgument');
}
?>