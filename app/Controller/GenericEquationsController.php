<?
class GenericEquationsController extends AppController {
  public $name = 'GenericEquation';
  
  public function create() {
    if($this->request->is('post') && $this->GenericEquation->save($this->request->data)) {
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