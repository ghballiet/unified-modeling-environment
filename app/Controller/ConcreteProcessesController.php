<?
class ConcreteProcessesController extends AppController {
  public $name = 'ConcreteProcess';
  
  public function create() {
    if($this->request->is('post') && $data = $this->ConcreteProcess->save($this->request->data)) {
      // set arguments
      $id = $data['ConcreteProcess']['id'];
      $numArgs = intval($data['ConcreteProcess']['num_arguments']);      
      for($i=0; $i<$numArgs; $i++) {
        $entity_id = $data['ConcreteProcess'][sprintf('argument-%d', $i)];
        $this->ConcreteProcess->ConcreteProcessArgument->create();
        $arg = array('ConcreteProcessArgument'=>array('concrete_process_id'=>$id,
                                                      'concrete_entity_id'=>$entity_id));
        $this->ConcreteProcess->ConcreteProcessArgument->save($arg);
      }
      
      $generic_process = $this->ConcreteProcess->GenericProcess->findById($data['ConcreteProcess']['generic_process_id']);
      foreach($generic_process['GenericEquation'] as $ge) {
        $arr = array('ConcreteEquation'=>array());
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