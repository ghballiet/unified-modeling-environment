<?
class ConcreteConditionsController extends AppController {
  public $name = 'ConcreteCondition';

  public function create() {
    if($this->request->is('post') && $data=$this->ConcreteCondition->save($this->request->data)) {
      $this->Session->setFlash('Condition successfully added.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $data['ConcreteCondition']['unified_model_id']));
    }
  }

  public function delete($id = null, $model = null) {
    if($this->ConcreteCondition->delete($id)) {
      $this->Session->setFlash('Condition successfully deleted.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }

  public function edit($id = null) {
    $this->ConcreteCondition->id = $id;
    if($this->request->is('post') && $data=$this->ConcreteCondition->save($this->request->data)) {
      $this->Session->setFlash('Condition successfully saved.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $data['ConcreteCondition']['unified_model_id']));
    }
  }
}
?>