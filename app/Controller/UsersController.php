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
        if($this->User->save($this->request->data)) {
          if($this->Auth->login())
            return $this->redirect($this->Auth->redirect());
        }
      }
    }
  }
}
?>