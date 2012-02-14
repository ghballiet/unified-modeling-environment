<?
class GenericEntity extends AppModel {
  public $name = 'GenericEntity';
  public $belongsTo = 'UnifiedModel';
  public $hasMany = array('GenericAttribute', 'ConcreteEntity', 'GenericProcessArgument');
}
?>