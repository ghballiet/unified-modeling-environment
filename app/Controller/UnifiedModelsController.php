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
    // $dbModel = $this->UnifiedModel->query(sprintf('SELECT * FROM unified_models AS UnifiedModel WHERE md5(id)=\'%s\'', $id));
    // if(sizeof($dbModel) == 0) {
    //   $this->Session->setFlash('You are not authorized to view that model.');
    //   $this->redirect(array('controller'=>'users', 'action'=>'models'));
    // }
    // $this->UnifiedModel->id = $dbModel[0]['UnifiedModel']['id'];
    $this->UnifiedModel->id = $id;
    $model = $this->UnifiedModel->read();
    if($model['User']['id'] != AuthComponent::user('id')) {
      $this->Session->setFlash('You are not authorized to view that model.');
      $this->redirect(array('controller'=>'users', 'action'=>'models'));
      return false;
    }
    $this->layout = 'lisp-generic';    
    $tmp_name = sprintf('model-%s', $id);
    $tmp_file = sprintf('/tmp/%s', $tmp_name);
    $this->set('tmp_name', $tmp_name);
    
    $id = $model['UnifiedModel']['id'];
    $entities = $this->UnifiedModel->GenericEntity->find('all', array('conditions'=>array(
      'GenericEntity.unified_model_id'=>$id)));
    $this->set('entities', $entities);
  }
  
  public function view($id = null) {
    // $dbModel = $this->UnifiedModel->query(sprintf('SELECT * FROM unified_models AS UnifiedModel WHERE md5(id)=\'%s\'', $id));
    // if(sizeof($dbModel) == 0) {
    //   $this->Session->setFlash('You are not authorized to view that model.');
    //   $this->redirect(array('controller'=>'users', 'action'=>'models'));
    // }
    // $this->UnifiedModel->id = $dbModel[0]['UnifiedModel']['id'];
    $this->UnifiedModel->id = $id;
    $model = $this->UnifiedModel->read();
    if($model['User']['id'] != AuthComponent::user('id')) {
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
        $args = $this->UnifiedModel->GenericProcess->GenericProcessArgument->find('all', array('conditions'=>array(
          'GenericProcessArgument.generic_process_id'=>$gp['GenericProcess']['id'])));
        foreach($args as $arg) {
          $params = array();
          $attrs = $this->UnifiedModel->GenericEntity->GenericAttribute->find('all', array('conditions'=>array(
            'GenericEntity.id'=>$arg['GenericEntity']['id'])));
          foreach($attrs as $attr)
            $params[$attr['GenericAttribute']['id']] = sprintf('%s.%s', $arg['GenericEntity']['name'], $attr['GenericAttribute']['name']);
          $arr[$arg['GenericEntity']['name']] = $params;
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
    }
  }
}
?>