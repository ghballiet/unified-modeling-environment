<?
class GenericAttribute extends AppModel {
  public $name = 'GenericAttribute';
  public $belongsTo = 'GenericEntity';
  public $hasMany = 'GenericEquation';
}
?>