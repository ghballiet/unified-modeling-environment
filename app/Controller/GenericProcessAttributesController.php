<?
class GenericProcessAttributesController extends AppController {
  public $name = 'GenericProcessAttribute';
  
  public function create() {
    if($this->request->is('post') && $this->GenericProcessAttribute->save($this->request->data)) {
      $this->Session->setFlash('Attribute successfully saved.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $this->request->data['GenericProcessAttribute']['model_id']));
    }
  }
  
  public function delete($id = null, $model = null) {
    if($this->GenericProcessAttribute->delete($id)) {
      $this->Session->setFlash('Attribute successfully deleted.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }

  public function edit($id = null) {
    $this->GenericProcessAttribute->id = $id;
    if($this->request->is('post') && $gpa = $this->GenericProcessAttribute->save($this->request->data)) {
      $this->Session->setFlash('Attribute successfully updated.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $gpa['GenericProcessAttribute']['unified_model_id']));
    }
  }
}
?>