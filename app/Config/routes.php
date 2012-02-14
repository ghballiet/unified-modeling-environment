<?php
/**
 * Routes configuration
 *
 * In this file, you set up routes to your controllers and their actions.
 * Routes are very important mechanism that allows you to freely connect
 * different urls to chosen controllers and their actions (functions).
 *
 * PHP 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2011, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2011, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Config
 * @since         CakePHP(tm) v 0.2.9
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
/**
 * Here, we are connecting '/' (base path) to controller called 'Pages',
 * its action called 'display', and we pass a param to select the view file
 * to use (in this case, /app/View/Pages/home.ctp)...
 */
 
Router::connect('/attributes/:action/*', array('controller'=>'attributes'));
Router::connect('/entity/:action/*', array('controller'=>'entities'));
Router::connect('/equation/:action/*', array('controller'=>'equation'));
Router::connect('/process/:action/*', array('controller'=>'process'));
Router::connect('/models/:action/*', array('controller'=>'unified_models'));
Router::connect('/generic_entities/:action/*', array('controller'=>'generic_entities'));
Router::connect('/generic_attributes/:action/*', array('controller'=>'generic_attributes'));
Router::connect('/generic_processes/:action/*', array('controller'=>'generic_processes'));
Router::connect('/generic_equations/:action/*', array('controller'=>'generic_equations'));
Router::connect('/generic_process_attributes/:action/*', array('controller'=>'generic_process_attributes'));
Router::connect('/concrete_entities/:action/*', array('controller'=>'concrete_entities'));
Router::connect('/concrete_attributes/:action/*', array('controller'=>'concrete_attributes'));
Router::connect('/concrete_processes/:action/*', array('controller'=>'concrete_processes'));
Router::connect('/concrete_process_attributes/:action/*', array('controller'=>'concrete_process_attributes'));
Router::connect('/concrete_equations/:action/*', array('controller'=>'concrete_equations'));
Router::connect('/:action/*', array('controller'=>'users'));
Router::connect('/', array('controller'=>'users', 'action'=>'models'));

/**
 * Load all plugin routes.  See the CakePlugin documentation on 
 * how to customize the loading of plugin routes.
 */
	CakePlugin::routes();

/**
 * Load the CakePHP default routes. Remove this if you do not want to use
 * the built-in default routes.
 */
	require CAKE . 'Config' . DS . 'routes.php';
