<?
class GenericEntitiesController extends AppController {
  public $name = 'GenericEntity';
  
  public function create() {
    if($this->request->is('post') && $this->GenericEntity->save($this->request->data)) {
      $this->Session->setFlash('Entity successfully created.');
      $this->redirect(array('controller'=>'models', 'action'=>'view', $this->request->data['GenericEntity']['unified_model_id']));
    }
  }
  
  public function delete($id = null, $model = null) {
    if($this->GenericEntity->delete($id, true)) {
      $this->Session->SetFlash('Entity successfully deleted.');
			$this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }
}
?>