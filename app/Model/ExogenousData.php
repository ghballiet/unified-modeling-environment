<?
class ExogenousData extends AppModel {
  public $name = 'ExogenousData';
  public $belongsTo = array('ConcreteAttribute', 'UnifiedModel');
}
?>