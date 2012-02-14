<?
class ConcreteEquationsController extends AppController {
  public $name = 'ConcreteEquation';
  
  public function create() {
    if($this->request->is('post') && $this->ConcreteEquation->save($this->request->data)) {
      $this->Session->setFlash('Equation successfully saved.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $this->request->data['ConcreteEquation']['model_id']));
    }
  }
}
?>