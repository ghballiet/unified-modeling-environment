<?
class GenericConditionsController extends AppController {
  public $name = 'GenericCondition';

  public function create() {
    if($this->request->is('post') && $data=$this->GenericCondition->save($this->request->data)) {
      // add the associated concrete condition
      $arr = array('ConcreteCondition'=>array());
      $generic_process = $this->GenericCondition->GenericProcess->findById($data['GenericCondition']['generic_process_id']);
      $old_val = $data['GenericCondition']['value'];
      $pid = $data['GenericCondition']['generic_process_id'];
      $generic_args = $this->GenericCondition->GenericProcess->GenericProcessArgument->find('list', 
        array('conditions'=>array('GenericProcessArgument.generic_process_id'=>$pid),
              'fields'=>array('GenericProcessArgument.id', 'GenericProcessArgument.generic_entity_id')));
      foreach($generic_process['ConcreteProcess'] as $cp) {
        $this->GenericCondition->ConcreteCondition->create();
        // now, for the tricky part: replace each pattern match
        // variable in the value with the correct concrete entity
        $val = $old_val;
        foreach($generic_args as $gpa=>$ge) {
          $ce = $this->GenericCondition->GenericProcess->ConcreteProcess->ConcreteProcessArgument->ConcreteEntity->findByGenericEntityId($ge);
          $val = str_replace(sprintf('?x%d', $gpa), $ce['ConcreteEntity']['name'], $val);
        }

        $arr['ConcreteCondition']['value'] = $val;
        $arr['ConcreteCondition']['concrete_process_id'] = $cp['id'];
        $arr['ConcreteCondition']['generic_condition_id'] = $data['GenericCondition']['id'];
        $this->GenericCondition->ConcreteCondition->save($arr);
      }

      $this->Session->setFlash('Condition successfully added.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $data['GenericCondition']['unified_model_id']));
    }
  }

  public function delete($id = null, $model = null) {
    $this->GenericCondition->id = $id;
    $gc = $this->GenericCondition->read();
    if($this->GenericCondition->delete($id)) {
      // delete any associated concrete conditions
      $concrete_conditions = $this->GenericCondition->ConcreteCondition->findAllByGenericConditionId($id);
      foreach($concrete_conditions as $cc)
        $this->GenericCondition->ConcreteCondition->delete($cc['ConcreteCondition']['id']);
      $this->Session->setFlash('Condition successfully deleted.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }

  public function edit($id = null) {
    $this->GenericCondition->id = $id;
    if($this->request->is('post') && $data=$this->GenericCondition->save($this->request->data)) {
      // update the concrete conditions
      $full_data = $this->GenericCondition->findById($id);
      foreach($full_data['ConcreteCondition'] as $cc) {
        $old_val = $data['GenericCondition']['value'];
        $pid = $data['GenericCondition']['generic_process_id'];
        $generic_args = $this->GenericCondition->GenericProcess->GenericProcessArgument->find('list', 
          array('conditions'=>array('GenericProcessArgument.generic_process_id'=>$pid),
                'fields'=>array('GenericProcessArgument.id', 'GenericProcessArgument.generic_entity_id')));
        // now, for the tricky part: replace each pattern match
        // variable in the value with the correct concrete entity
        $val = $old_val;
        foreach($generic_args as $gpa=>$ge) {
          $ce = $this->GenericCondition->GenericProcess->ConcreteProcess->ConcreteProcessArgument->ConcreteEntity->findByGenericEntityId($ge);
          $val = str_replace(sprintf('?x%d', $gpa), $ce['ConcreteEntity']['name'], $val);
        }
      }
      
      $this->Session->setFlash('Condition successfully saved.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $data['GenericCondition']['unified_model_id']));
    } 
  }
}
?>
