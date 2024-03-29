<?
class ConcreteProcessAttributesController extends AppController {
  public $name = 'ConcreteProcessAttribute';
  
  public function create() {
    if($this->request->is('post') && $this->ConcreteProcessAttribute->save($this->request->data)) {
      $this->Session->setFlash('Attribute successfully added.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $this->request->data['ConcreteProcessAttribute']['model_id']));
    }
  }
  
  public function delete($id = null, $model = null) {
    if($this->ConcreteProcessAttribute->delete($id)) {
      $this->Session->setFlash('Attribute successfully deleted.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }
}
?>