<?
class GenericEquation extends AppModel {
  public $name = 'GenericEquation';
  public $belongsTo = array('GenericProcess', 'GenericAttribute', 'GenericProcessArgument');
}
?>