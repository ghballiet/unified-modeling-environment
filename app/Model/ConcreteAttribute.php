<?
class ConcreteAttribute extends AppModel {
  public $name = 'ConcreteAttribute';
  public $belongsTo = 'ConcreteEntity';
  public $hasMany = 'ConcreteEquation';
}
?>