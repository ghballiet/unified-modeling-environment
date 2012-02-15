<?
class ExogenousValuesController extends AppController {
  public $name = 'ExogenousValue';

  public function create() {
    pr($this->request->data);
  }

  public function edit() {
  }
}
?>