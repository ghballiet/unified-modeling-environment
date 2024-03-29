<?
class GenericAttributesController extends AppController {
  public $name = 'GenericAttribute';
  
  public function create() {
    if($this->request->is('post') && $this->GenericAttribute->save($this->request->data)) {
      $this->Session->setFlash('Attribute successfully created.');
      $this->redirect(array('controller'=>'models', 'action'=>'view', $this->request->data['GenericAttribute']['unified_model_id']));
    }
  }

	public function delete($id = null, $model) {
		if($this->GenericAttributesController->delete($id)) {
			$this->Session->setFlash('Entity successfully deleted.');
			$this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
		}
	}
}
?>