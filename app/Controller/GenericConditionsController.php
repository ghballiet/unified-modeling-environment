<?
class GenericConditionsController extends AppController {
  public $name = 'GenericCondition';

  public function create() {
    if($this->request->is('post') && $data=$this->GenericCondition->save($this->request->data)) {
      // add the associated concrete condition
      $arr = array('ConcreteCondition'=>array());
      $generic_process = $this->GenericCondition->GenericProcess->findById($data['GenericCondition']['generic_process_id']);
      foreach($generic_process['ConcreteProcess'] as $cp) {
        $this->GenericCondition->GenericProcess->ConcreteProcess->ConcreteCondition->create();
        $arr['ConcreteCondition']['value'] = $data['GenericCondition']['value'];
        $arr['ConcreteCondition']['concrete_process_id'] = $cp['id'];
        $this->GenericCondition->GenericProcess->ConcreteProcess->ConcreteCondition->save($arr);
      }

      $this->Session->setFlash('Condition successfully added.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $data['GenericCondition']['unified_model_id']));
    }
  }

  public function delete($id = null, $model = null) {
    if($this->request->is('post') && $this->GenericCondition->delete($id)) {
      $this->Session->setFlash('Condition successfully deleted.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }

  public function edit($id = null) {
    $this->GenericCondition->id = $id;
    if($this->request->is('post') && $data=$this->GenericCondition->save($this->request->data)) {
      $this->Session->setFlash('Condition successfully saved.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $data['GenericCondition']['unified_model_id']));
    } 
  }
}
?>