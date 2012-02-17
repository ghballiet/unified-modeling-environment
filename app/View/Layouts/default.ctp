<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><? echo $title_for_layout; ?> | Unified Modeling Framework</title>
    <script src="http://code.jquery.com/jquery-1.6.4.min.js"></script>
    <link href="http://fonts.googleapis.com/css?family=Signika+Negative:300,400,600,700|Crete+Round|Ubuntu+Mono:400,700,400italic" rel="stylesheet" type="text/css">
<?
echo $this->Html->script('jquery.reveal');
echo $this->Html->css('default');
echo $this->Html->css('forms');
echo $this->Html->css('reveal');
echo $this->Html->css(sprintf('%s-%s', $this->params['controller'], $this->params['action']));
echo $this->Html->script('less-1.2.1.min');
echo $this->Html->script(sprintf('%s-%s', $this->params['controller'], $this->params['action']));
?>
  </head>
  <body>
    <div id="header">
      <div class="wrapper">
        <div id="nav">          
<?
if(AuthComponent::user() != null) {
  echo $this->Html->link('View Models', array('controller'=>'users', 'action'=>'models'));
  echo $this->Html->link('Logout', array('controller'=>'users', 'action'=>'logout'));
} else {
  echo $this->Html->link('Login', array('controller'=>'users', 'action'=>'login'), array('data-icon'=>'home'));
  echo $this->Html->link('Register', array('controller'=>'users', 'action'=>'register'), array('data-icon'=>'check', 'data-transition'=>'flip'));
}
?>
        </div>
        <div class="clearfix"></div>
      </div>
    </div>
    <div id="content">
      <div class="wrapper">        
<?
echo $this->Session->flash();
echo $this->Session->flash('Auth');
echo $content_for_layout;
?>
      </div>
    </div>
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-29187830-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
  </body>
</html>
