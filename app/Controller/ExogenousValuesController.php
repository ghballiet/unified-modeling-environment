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
    pr($this->request->data);
  }
}
?>