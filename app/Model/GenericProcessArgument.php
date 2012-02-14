<?
class GenericProcessArgument extends AppModel {
  public $name = 'GenericProcessArgument';
  public $belongsTo = array('GenericProcess', 'GenericEntity');
}
?>