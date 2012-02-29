<?
class ConcreteEntitiesController extends AppController {
  public $name = 'ConcreteEntity';
  
  public function create() {
    if($this->request->is('post') && $ce=$this->ConcreteEntity->save($this->request->data)) {
      $this->Session->setFlash('Entity successfully created.');

      // add inherited attributes (from the generic entity)
      $gid = $this->request->data['ConcreteEntity']['generic_entity_id'];
      $attrs = $this->ConcreteEntity->UnifiedModel->GenericEntity->GenericAttribute->findAllByGenericEntityId($gid);
      foreach($attrs as $a) {
        $this->ConcreteEntity->ConcreteAttribute->create();
        $arr = array('ConcreteAttribute'=>array('name'=>$a['GenericAttribute']['name'],
                                                'value'=>$a['GenericAttribute']['value'],
                                                'concrete_entity_id'=>$ce['ConcreteEntity']['id']));
        $this->ConcreteEntity->ConcreteAttribute->save($arr);
      }

      $this->redirect(array('controller'=>'models', 'action'=>'view', $this->request->data['ConcreteEntity']['unified_model_id']));
    }
  }
  
  public function delete($id = null, $model = null) {
    if($this->ConcreteEntity->delete($id)) {
      $this->Session->SetFlash('Entity successfully deleted.');
			$this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }

  public function edit($id = null) {
    $this->layout = 'simulate';
    $this->ConcreteEntity->id = $id;
    if($this->request->is('post') && $this->ConcreteEntity->save($this->request->data)) {
      $response = array('msg'=>'Entity updated.', 'data'=>$this->ConcreteEntity->read());
      print json_encode($response);
    }
  }
}
?>