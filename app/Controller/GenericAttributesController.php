<?
class GenericAttributesController extends AppController {
  public $name = 'GenericAttribute';
  
  public function create() {
    if($this->request->is('post') && $this->GenericAttribute->save($this->request->data)) {
      $this->Session->setFlash('Attribute successfully created.');
      $this->redirect(array('controller'=>'models', 'action'=>'view', $this->request->data['GenericAttribute']['unified_model_id']));
    }
  }

  public function delete($id = null, $model = null) {
    if($this->GenericAttribute->delete($id)) {
      $this->Session->setFlash('Attribute successfully deleted.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }

  public function edit($id = null) {
    $this->GenericAttribute->id = $id;
    if($this->request->is('post') && $this->GenericAttribute->save($this->request->data)) {
      $this->Session->setFlash('Attribute successfully updated.');
      $modelId = $this->request->data['GenericAttribute']['unified_model_id'];
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $modelId));
    }
  }
}
?>