<?
class ExogenousValuesController extends AppController {
  public $name = 'ExogenousValue';

  public function create() {
    if($this->request->is('post') && $this->ExogenousValue->save($this->request->data)) {
      $this->Session->setFlash('Exogenous value successfully saved.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view',
        $this->request->data['ExogenousValue']['unified_model_id']));
    }
  }

  public function edit() {
    if(!$this->request->is('post'))
      return false;
    
    $modelId = $this->request->data['ExogenousValue']['unified_model_id'];
    $ex = $this->ExogenousValue->findByUnifiedModelId($modelId);
    if($ex!=null)
      $this->ExogenousValue->id = $ex['ExogenousValue']['id'];
    else
      $this->ExogenousValue->create();
    $this->ExogenousValue->save($this->request->data);
    $this->Session->setFlash('Exogenous data saved.');
    $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $modelId));
  }

  public function delete($id = null, $model = null) {
    if($this->ExogenousValue->delete($id)) {
      $this->Session->setFlash('Exogenous value successfully deleted.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $model));
    }
  }
}
?>