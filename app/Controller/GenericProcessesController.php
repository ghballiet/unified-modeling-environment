<?
class GenericProcessesController extends AppController {
  public $name = 'GenericProcess';
  
  public function create() {
    if($this->request->is('post') && $data = $this->GenericProcess->save($this->request->data)) {
      // set arguments
      $id = $data['GenericProcess']['id'];
      print_r($data);
      $num = intval($this->request->data['GenericProcess']['num_arguments']);
      $num++;
      for($i=1; $i<=$num; $i++) {
        $this->GenericProcess->GenericProcessArgument->create();
        $entityId = $this->request->data['GenericProcess']['argument-' . $i];
        $arg = array('GenericProcessArgument'=>array('generic_process_id'=>$id, 'generic_entity_id'=>$entityId));
        $this->GenericProcess->GenericProcessArgument->save($arg);
      }
      $this->Session->setFlash('Process successfully saved.');
      $this->redirect(sprintf('/models/view/%s', $this->request->data['GenericProcess']['unified_model_id']));
    }
  }
  
  public function delete($id = null, $model = null) {
    if($this->GenericProcess->delete($id, true)) {
      $this->Session->setFlash('Process successfully deleted.'); 
			$this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }
}
?>