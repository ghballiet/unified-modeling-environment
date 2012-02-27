<?
class UnifiedModelsController extends AppController {
  public $name = 'UnifiedModel';
  
  public function create() {
    if($this->UnifiedModel->save($this->request->data)) {
      $this->Session->setFlash('Model successfully created.');
      $this->redirect(array('controller'=>'users', 'action'=>'models'));
    }
  }
  
  public function delete($id = null) {
    if($this->UnifiedModel->delete($id, true)) {
      $this->Session->setFlash('Model successfully deleted.');
      $this->redirect(array('controller'=>'users', 'action'=>'models'));
    }
  }

  public function lisp_generic($id = null) {
    $this->layout = 'simulate';
    $this->UnifiedModel->id = $id;
    $model = $this->UnifiedModel->read();
    $generic_entities = $this->UnifiedModel->GenericEntity->findAllByUnifiedModelId($id);
    $generic_attributes = $this->UnifiedModel->GenericEntity->GenericAttribute->find('all', array(
      'conditions'=>array('GenericEntity.unified_model_id'=>$id)));
    $generic_processes = $this->UnifiedModel->GenericProcess->findAllByUnifiedModelId($id);
    $generic_equations = $this->UnifiedModel->GenericProcess->GenericEquation->find('all', array(
      'conditions'=>array('GenericProcess.unified_model_id'=>$id)));
    $generic_entity_list = $this->UnifiedModel->GenericEntity->find('list', array('conditions'=>array(
       'GenericEntity.unified_model_id'=>$id)));

    // grab the variables, by entity id
    $generic_variables = array();
    $generic_variable_list = array();
    foreach($generic_equations as $ge) {
      $eid = $ge['GenericAttribute']['generic_entity_id'];
      if(!array_key_exists($eid, $generic_variables))
        $generic_variables[$eid] = array();
      if(!array_key_exists($eid, $generic_variable_list))
        $generic_variable_list[$eid] = array();
      $generic_variables[$eid][] = $ge;
      $generic_variable_list[$eid][] = $ge['GenericAttribute']['id'];
    }

    // grab the constants, by entity id
    $generic_constants = array();
    foreach($generic_variable_list as $eid => $gv) {
      $res = $this->UnifiedModel->GenericEntity->GenericAttribute->find('all', array('conditions'=>array(
        'GenericEntity.id'=>$eid, 'NOT' => array('GenericAttribute.id'=>$gv))));
      $generic_constants[$eid] = $res;
    }

    // build the equation list by process id
    $generic_equation_list = array();
    foreach($generic_processes as $gp) {
      $res = $this->UnifiedModel->GenericProcess->GenericEquation->findAllByGenericProcessId($gp['GenericProcess']['id']);
      $generic_equation_list[$gp['GenericProcess']['id']] = $res;
    }
    
    $this->set('model', $model);
    $this->set('generic_entities', $generic_entities);
    $this->set('generic_attributes', $generic_attributes);
    $this->set('generic_processes', $generic_processes);
    $this->set('generic_equations', $generic_equations);
    $this->set('generic_variables', $generic_variables);
    $this->set('generic_constants', $generic_constants);
    $this->set('generic_equation_list', $generic_equation_list);
    $this->set('generic_entity_list', $generic_entity_list);
  }

  public function simulate($id = null) {
    $this->layout = 'simulate';
    $this->UnifiedModel->id = $id;
    $model = $this->UnifiedModel->read();
    $this->set('model', $model);
    // grab model information
    $concrete_entities = $this->UnifiedModel->ConcreteEntity->find('all', array('conditions'=>array(
      'ConcreteEntity.unified_model_id'=>$id)));
    $concrete_entity_list = $this->UnifiedModel->ConcreteEntity->find('list', array('conditions'=>array(
      'ConcreteEntity.unified_model_id'=>$id)));
    $concrete_processes = $this->UnifiedModel->ConcreteProcess->find('all', array('conditions'=>array(
      'ConcreteProcess.unified_model_id'=>$id)));
    $concrete_attrs = $this->UnifiedModel->ConcreteEntity->ConcreteAttribute->find('all',
      array('conditions'=>array('ConcreteEntity.unified_model_id'=>$id)),
      array('group'=>array('ConcreteEntity.id')));
    $concrete_equations = $this->UnifiedModel->ConcreteProcess->ConcreteEquation->find('all',
      array('conditions'=>array('ConcreteProcess.unified_model_id'=>$id)));
    $exogenous_data = $this->UnifiedModel->ExogenousValue->findByUnifiedModelId($id);
    
    // set model information
    $this->set('concrete_entities', $concrete_entities);
    $this->set('concrete_entity_list', $concrete_entity_list);
    $this->set('concrete_processes', $concrete_processes);
    $this->set('concrete_attrs', $concrete_attrs);
    $this->set('concrete_equations', $concrete_equations);
    $this->set('exogenous_data', $exogenous_data);
    $this->set('user', $this->UnifiedModel->User->findById($model['UnifiedModel']['user_id']));

    // display stuff correctly
    if($this->request->is('get'))
      $this->set('debug', true);
  }
  
  public function view($id = null) {
    $this->UnifiedModel->id = $id;
    $model = $this->UnifiedModel->read();
    $user = $this->UnifiedModel->User->findById($this->Auth->user('id'));
    if(($model['User']['id'] != $user['User']['id']) && $user['User']['is_admin'] == 0) {
      $this->Session->setFlash('You are not authorized to view that model.');
      $this->redirect(array('controller'=>'users', 'action'=>'models'));
    } else {
      $this->set('model', $model);
      $id = $model['UnifiedModel']['id'];
      $generic_entities = $this->UnifiedModel->GenericEntity->find('all', array('conditions'=>array(
        'GenericEntity.unified_model_id'=>$id)));
      $generic_attributes = $this->UnifiedModel->GenericEntity->GenericAttribute->find('all', array('conditions'=>array(
        'GenericEntity.unified_model_id'=>$id)));
      $generic_entity_list = $this->UnifiedModel->GenericEntity->find('list', array('conditions'=>array(
        'GenericEntity.unified_model_id'=>$id)));
      $generic_processes = $this->UnifiedModel->GenericProcess->find('all', array('conditions'=>array(
        'GenericProcess.unified_model_id'=>$id)));
      $generic_process_list = $this->UnifiedModel->GenericProcess->find('list', array('conditions'=>array(
        'GenericProcess.unified_model_id'=>$id)));
      $generic_equations = array();
      $generic_process_arguments = array();      
      foreach($generic_processes as $gp) {
        // add equations
        $eqn = array();
        $eq = $this->UnifiedModel->GenericProcess->GenericEquation->find('all', array('conditions'=>array(
          'GenericEquation.generic_process_id'=>$gp['GenericProcess']['id'])));
        foreach($eq as $k=>$q) {
          $entity = $this->UnifiedModel->GenericEntity->findById($q['GenericAttribute']['generic_entity_id']);
          $q['GenericEntity'] = $entity['GenericEntity'];
          $eqn[$k] = $q;
        }
        $generic_equations[$gp['GenericProcess']['id']] = $eqn;
        
        // add arguments
        $arr = array();
        $args = $this->UnifiedModel->GenericProcess->GenericProcessArgument->find('all', 
          array('conditions'=>array('GenericProcessArgument.generic_process_id'=>$gp['GenericProcess']['id'])));
        foreach($args as $arg) {
          $params = array();
          $attrs = $this->UnifiedModel->GenericEntity->GenericAttribute->find('all', array('conditions'=>array(
            'GenericEntity.id'=>$arg['GenericEntity']['id'])));
          foreach($attrs as $attr) {
            $params[sprintf('%s:%s', $attr['GenericAttribute']['id'], $arg['GenericProcessArgument']['id'])] = sprintf('?x%s.%s', 
              $arg['GenericProcessArgument']['id'], $attr['GenericAttribute']['name']);
          }
          $arr[sprintf('%s ?x%s', $arg['GenericEntity']['name'], $arg['GenericProcessArgument']['id'])] = 
            $params;
        }
        $generic_process_arguments[$gp['GenericProcess']['id']] = $arr;
      }
      $concrete_entities = $this->UnifiedModel->ConcreteEntity->find('all', array('conditions'=>array(
        'ConcreteEntity.unified_model_id'=>$id)));
      $concrete_entity_list = $this->UnifiedModel->ConcreteEntity->find('list', array('conditions'=>array(
        'ConcreteEntity.unified_model_id'=>$id)));
      $concrete_processes = $this->UnifiedModel->ConcreteProcess->find('all', array('conditions'=>array(
        'ConcreteProcess.unified_model_id'=>$id)));
      $concrete_equations = array();
      $concrete_process_arguments = array();      
      foreach($concrete_processes as $gp) {
        // add equations
        $eqn = array();
        $eq = $this->UnifiedModel->ConcreteProcess->ConcreteEquation->find('all', array('conditions'=>array(
          'ConcreteEquation.concrete_process_id'=>$gp['ConcreteProcess']['id'])));
        foreach($eq as $k=>$q) {
          $entity = $this->UnifiedModel->ConcreteEntity->findById($q['ConcreteAttribute']['concrete_entity_id']);
          $q['ConcreteEntity'] = $entity['ConcreteEntity'];
          $eqn[$k] = $q;
        }
        $concrete_equations[$gp['ConcreteProcess']['id']] = $eqn;
        
        // add arguments
        $arr = array();
        $args = $this->UnifiedModel->ConcreteProcess->ConcreteProcessArgument->find('all', array('conditions'=>array(
          'ConcreteProcessArgument.concrete_process_id'=>$gp['ConcreteProcess']['id'])));
        foreach($args as $arg) {
          $params = array();
          $attrs = $this->UnifiedModel->ConcreteEntity->ConcreteAttribute->find('all', array('conditions'=>array(
            'ConcreteEntity.id'=>$arg['ConcreteEntity']['id'])));
          foreach($attrs as $attr)
            $params[$attr['ConcreteAttribute']['id']] = sprintf('%s.%s', $arg['ConcreteEntity']['name'], $attr['ConcreteAttribute']['name']);
          $arr[$arg['ConcreteEntity']['name']] = $params;
        }
        $concrete_process_arguments[$gp['ConcreteProcess']['id']] = $arr;
      }

      // concrete process argument stuff
      $concrete_process_argument_list = array();
      foreach($generic_processes as $gp) {
        // add generic process arguments
        $row = array();
        $args = $this->UnifiedModel->GenericProcess->GenericProcessArgument->find('all', array('conditions'=>array(
          'GenericProcessArgument.generic_process_id'=>$gp['GenericProcess']['id'])));
        foreach($args as $a) {
          $ce = $this->UnifiedModel->ConcreteEntity->find('list', array('conditions'=>array(
            'ConcreteEntity.generic_entity_id'=>$a['GenericEntity']['id'])));
          // $row[$a['GenericProcessArgument']['id']] = $ce;
          $row[] = $ce;
        }
        $concrete_process_argument_list[$gp['GenericProcess']['id']] = $row;
      }

      // exogenous values
      $exogenous_values = $this->UnifiedModel->ExogenousValue->findByUnifiedModelId($id);

      // empirical data
      $empirical_data = $this->UnifiedModel->EmpiricalObservation->findByUnifiedModelId($id);

      $this->set('generic_entities', $generic_entities);
      $this->set('generic_attributes', $generic_attributes);
      $this->set('generic_entity_list', $generic_entity_list);
      $this->set('generic_processes', $generic_processes);
      $this->set('generic_process_list', $generic_process_list);
      $this->set('generic_equations', $generic_equations);
      $this->set('generic_process_arguments', $generic_process_arguments);
      $this->set('concrete_entities', $concrete_entities);
      $this->set('concrete_entity_list', $concrete_entity_list);
      $this->set('concrete_processes', $concrete_processes);
      $this->set('concrete_equations', $concrete_equations);
      $this->set('concrete_process_arguments', $concrete_process_arguments);
      $this->set('concrete_process_argument_list', $concrete_process_argument_list);
      $this->set('exogenous_values', $exogenous_values);
      $this->set('empirical_data', $empirical_data);
    }
  }
}
?>