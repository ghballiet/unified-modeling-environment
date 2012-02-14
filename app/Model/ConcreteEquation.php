<?
class ConcreteEquation extends AppModel {
  public $name = 'ConcreteEquation';
  public $belongsTo = array('ConcreteProcess', 'ConcreteAttribute');
}
?>