<?
class ConcreteAttributesController extends AppController {
  public $name = 'ConcreteAttribute';
  
  public function create() {
    if($this->request->is('post') && $this->ConcreteAttribute->save($this->request->data)) {
      $this->Session->setFlash('Attribute saved successfully.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $this->request->data['ConcreteAttribute']['unified_model_id']));
    }
  }
  
  public function delete($id = null, $model = null) {
    if($this->ConcreteAttribute->delete($id)) {
      $this->Session->setFlash('Attribute deleted successfully.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }
}
?>