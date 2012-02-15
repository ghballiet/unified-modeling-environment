<?
class UnifiedModel extends AppModel {
  public $name = 'UnifiedModel';
  public $belongsTo = 'User';
  public $hasMany = array('GenericEntity', 'GenericProcess', 'ConcreteEntity', 'ConcreteProcess', 
                          'ExogenousValue');
}
?>