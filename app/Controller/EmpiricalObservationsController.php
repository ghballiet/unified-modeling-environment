<?
class EmpiricalObservationsController extends AppController {
  public $name = 'EmpiricalObservation';
  
  public function create() {
    if($this->request->is('post') && $this->EmpiricalObservation->save($this->request->data)) {
      $this->Session->setFlash('Empirical data successfully saved.');
      $this->redirect(array('controller'=>'unified_models', 'action'=>'view',
                            $this->request->data['EmpiricalObservation']['unified_model_id']));
    }
  }

  public function edit() {
    if(!$this->request->is('post'))
      return false;

    $modelId = $this->request->data['EmpiricalObservation']['unified_model_id'];
    $eo = $this->EmpiricalObservation->findByUnifiedModelId($modelId);
    if($eo != null)
      $this->EmpiricalObservation->id = $eo['EmpiricalObservation']['id'];
    else
      $this->EmpiricalObservation->create();
    $this->EmpiricalObservation->save($this->request->data);
    $this->Session->setFlash('Empirical data saved.');
    $this->redirect(array('controller'=>'unified_models', 'action'=>'view', $modelId));
  }
}
?>