<?
class UsersController extends AppController {
  public $name = 'User';
  
  public function login() {
    if($this->Auth->user() != null)
      $this->redirect(array('action'=>'models'));
    if($this->request->is('post')) {
      if($this->Auth->login()) {
        return $this->redirect($this->Auth->redirect());
      } else {
        $this->Session->setFlash('Username or password is incorrect.');
      }
    }
  }
  
  public function logout() {
    $this->redirect($this->Auth->logout());
  }
  
  public function beforeFilter() {
    // $this->Auth->fields = array(
    //   'username' => 'email',
    //   'password' => 'password'
    // );
    $this->Auth->allow('submission_info', 'index', 'login', 'register');
    $this->User->id = $this->Auth->user('id');
    $user = $this->User->read();
    $this->set('user', $user);
  }
  
  public function models() {
    $this->set('models', $this->User->UnifiedModel->find('all', array(
      'conditions'=>array('UnifiedModel.user_id'=>AuthComponent::user('id')))));
  }
  
  public function register() {
    if($this->Auth->user() != null)
      $this->redirect(array('action'=>'models'));
    if($this->request->is('post')) {
      if($this->request->data['User']['email'] != $this->request->data['User']['emailConfirm']) {
        $this->Session->setFlash('Error: the email addresses you entered did not match.');
        return false;
      } else if($this->request->data['User']['password'] != $this->request->data['User']['passwordConfirm']) {
        $this->Session->setFlash('Error: the passwords you entered did not match.');
        return false;
      } else {
        // all valid data so far
        $user = null;
        if($user = $this->User->save($this->request->data)) {
          $id = $user['User']['id'];
          $m1 = array('UnifiedModel'=>array(
            'name'=>'Traffic and Lung Disease',
            'description'=>'Traffic and Lung Disease Model',
            'user_id'=>$id
          ));
          $m2 = array('UnifiedModel'=>array(
            'name'=>'Hunter and Game',
            'description'=>'Hunter and Game Model',
            'user_id'=>$id
          ));

          // create the models
          $this->User->UnifiedModel->create();
          $model1 = $this->User->UnifiedModel->save($m1);
          $this->User->UnifiedModel->create();
          $model2 = $this->User->UnifiedModel->save($m2);

          // create the generic entities
          $ge1 = array('GenericEntity'=>array('name'=>'GenericEntity', 'unified_model_id'=>$model1['UnifiedModel']['id']));
          $ge2 = array('GenericEntity'=>array('name'=>'GenericEntity', 'unified_model_id'=>$model2['UnifiedModel']['id']));
          $this->User->UnifiedModel->GenericEntity->create();
          $entity1 = $this->User->UnifiedModel->GenericEntity->save($ge1);
          $this->User->UnifiedModel->GenericEntity->create();
          $entity2 = $this->User->UnifiedModel->GenericEntity->save($ge2);

          // create the generic processes
          $gp1 = array('GenericProcess'=>array('name'=>'GenericProcess', 'unified_model_id'=>$model1['UnifiedModel']['id']));
          $gp2 = array('GenericProcess'=>array('name'=>'GenericProcess', 'unified_model_id'=>$model2['UnifiedModel']['id']));
          $this->User->UnifiedModel->GenericProcess->create();
          $process1 = $this->User->UnifiedModel->GenericProcess->save($gp1);
          $this->User->UnifiedModel->GenericProcess->create();
          $process2 = $this->User->UnifiedModel->GenericProcess->save($gp2);

          // create the generic process arguments
          $gpa1 = array('GenericProcessArgument'=>
                        array('generic_process_id'=>$process1['GenericProcess']['id'], 'generic_entity_id'=>$entity1['GenericEntity']['id']));
          $gpa2 = array('GenericProcessArgument'=>
                        array('generic_process_id'=>$process2['GenericProcess']['id'], 'generic_entity_id'=>$entity2['GenericEntity']['id']));
          $this->User->UnifiedModel->GenericProcess->GenericProcessArgument->create();
          $this->User->UnifiedModel->GenericProcess->GenericProcessArgument->save($gpa1);
          $this->User->UnifiedModel->GenericProcess->GenericProcessArgument->create();
          $this->User->UnifiedModel->GenericProcess->GenericProcessArgument->save($gpa2);

          if($this->Auth->login())
            return $this->redirect($this->Auth->redirect());
        }
      }
    }
  }
}
?>