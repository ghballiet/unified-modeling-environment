<?
class ConcreteProcessesController extends AppController {
  public $name = 'ConcreteProcess';
  
  public function create() {
    if($this->request->is('post') && $data = $this->ConcreteProcess->save($this->request->data)) {
      // set arguments
      $id = $data['ConcreteProcess']['id'];
      foreach($this->request->data['ConcreteProcess']['arguments'] as $entityId) {
        $this->ConcreteProcess->ConcreteProcessArgument->create();
        $arg = array('ConcreteProcessArgument'=>array('concrete_process_id'=>$id, 'concrete_entity_id'=>$entityId));
        $this->ConcreteProcess->ConcreteProcessArgument->save($arg);
      }
      $this->Session->setFlash('Process successfully saved.');
      $this->redirect(sprintf('/models/view/%s', $this->request->data['ConcreteProcess']['unified_model_id']));
    }
  }

  public function delete($id = null, $model = null) {
    if($this->ConcreteProcess->delete($id, true)) {
			$this->Session->setFlash('Process succesfully deleted.');
		  $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }
}
?>