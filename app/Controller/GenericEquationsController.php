<?
class GenericEquationsController extends AppController {
  public $name = 'GenericEquation';
  
  public function create() {
    $data = $this->request->data;
    $val = $data['GenericEquation']['generic_attribute_id'];
    $val = split(':', $val);
    $attrId = intval($val[0]);
    $argId = intval($val[1]);
    $data['GenericEquation']['generic_attribute_id'] = $attrId;
    $data['GenericEquation']['generic_process_argument_id'] = $argId;
    if($this->request->is('post') && $this->GenericEquation->save($data)) {
      $this->Session->setFlash('Equation successfully added.');
      $this->redirect(array('controller'=>'models', 'action'=>'view', $this->request->data['GenericEquation']['model_id']));
    }
  }
  
  public function delete($id = null, $model = null) {
    if($this->GenericEquation->delete($id)) {
      $this->Session->setFlash('Equation successfully deleted.');
			$this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }
}
?>