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
      
      // add all the information from the generic process we've selected into the concrete process
      $generic_process = $this->ConcreteProcess->GenericProcess->findById(
        $data['ConcreteProcess']['generic_process_id']);

      // add the process attributes
      foreach($generic_process['GenericProcessAttribute'] as $gpa) {
        $this->ConcreteProcess->ConcreteProcessAttribute->create();
        $arr = array('ConcreteProcessAttribute'=>array(
          'name'=>$gpa['name'], 'value'=>$gpa['value'], 'concrete_process_id'=>$id));
        $this->ConcreteProcess->ConcreteProcessAttribute->save($arr);
      }
      
      // add the equations
      foreach($generic_process['GenericEquation'] as $ge) {
        $arr = array('ConcreteEquation'=>array());
        $this->ConcreteProcess->ConcreteEquation->create();
        $arr['ConcreteEquation']['is_algebraic'] = $ge['is_algebraic'];
        $arr['ConcreteEquation']['concrete_process_id'] = $id;

        // we have to search through the right hand side of the
        // generic equation, replacing ?x[generic_process_argument_id]
        // with [concrete_entity_name]
        $old_rhs = $ge['right_hand_side'];
        $rhs = $old_rhs;
        foreach($generic_process['GenericProcessArgument'] as $gpa) {
          $pe = $this->ConcreteProcess->ConcreteProcessArgument->ConcreteEntity->findByGenericEntityId($gpa['generic_entity_id']);
          $rhs = str_replace(sprintf('?x%d', $gpa['id']), $pe['ConcreteEntity']['name'], $rhs);
        }
        $arr['ConcreteEquation']['right_hand_side'] = $rhs;

        // setting the left hand side (concrete_attribute_id) is going
        // to be a bit tricky - we have to find the right attribute in
        // the process arguments

        // first, get the generic attribute that is being used
        $attr = $this->ConcreteProcess->GenericProcess->GenericEquation->GenericAttribute->findById(
          $ge['generic_attribute_id']);

        // next, find the concrete attribute which corresponds to this
        // generic attribute. NOTE: in order for this to work, no
        // concrete entity can have two attributes with the same
        // name (which is a reasonable assumption regardless)
        $cattr = $this->ConcreteProcess->ConcreteProcessArgument->ConcreteEntity->ConcreteAttribute->find('first',
          array('conditions'=>array(
            'ConcreteEntity.generic_entity_id'=>$attr['GenericEntity']['id'],
            'ConcreteAttribute.name'=>$attr['GenericAttribute']['name'])));
        
        // hopefully we have the correct concrete attribute id at this
        // point 
        $arr['ConcreteEquation']['concrete_attribute_id'] = $cattr['ConcreteAttribute']['id'];

        // now, we can just save the equation
        $this->ConcreteProcess->ConcreteEquation->save($arr);
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