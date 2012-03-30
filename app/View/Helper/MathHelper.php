<?
App::uses('AppHelper', 'View/Helper');

class MathHelper extends AppHelper {
  var $suppress_errors = false;
  var $last_error = null;
    
  var $v = array('e'=>2.71,'pi'=>3.14); // variables (and constants)
  var $f = array(); // user-defined functions
  var $vb = array('e', 'pi'); // constants
  var $fb = array(  // built-in functions
                  'sin','sinh','arcsin','asin','arcsinh','asinh',
                  'cos','cosh','arccos','acos','arccosh','acosh',
                  'tan','tanh','arctan','atan','arctanh','atanh',
                  'sqrt','abs','ln','log');

  function rand_string($length) {
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";	
    $size = strlen($chars);
    $str = '';
    for($i = 0; $i < $length; $i++) {
      $str .= $chars[rand(0, $size - 1)];
    }
    return $str;
  }

  function conv($rhs) {
    $rhs = trim(str_replace('?', '', $rhs));
    $matches = null;
    $conversions = array();
    $mappings = array('>='=>'&', '<='=>'%');
    $lisp_mappings = array('&'=>'>=', '%'=>'<=', '^'=>'expt');
    $hide_functions = array('rand', 'max');
    $replace_hidden = array();
    $replaced = 0;

    // do some fat-finger replacement
    $rhs = str_replace('str {', 'str{', $rhs);

    // hide these functions from the equation parser
    foreach($hide_functions as $func) {
      $preg_str = sprintf('/%s\([\w|\.]+,\s*[\w|\.]+\)/', $func);
      preg_match_all($preg_str, $rhs, $func_matches);
      foreach($func_matches as $f) {
        if(!isset($f[0]))
          continue;
        $old = $f[0];
        $new = sprintf('replaced%s', $replaced);
        $replace_hidden[$new] = array('type'=>$func, 'old'=>$old);
        $rhs = str_replace($old, $new, $rhs);        
        $replaced++;
      }
    }

    // parse the functions separately, grabbing the full string and the inside
    preg_match_all('|[a-z]+\{(.*)\}|U', $rhs, $matches);
    $full_matches = $matches[0];
    $interior_matches = $matches[1];

    // convert the operators appropriately
    foreach($mappings as $k=>$v) {
      $rhs = str_replace($k, $v, $rhs);
    }

    // replace the inside of each function with a single variable, and
    // store the postfix equivalent of the inside 
    foreach($full_matches as $i=>$fm) {
      $im = $interior_matches[$i];
      $converted = $this->toLisp($im);
      $varname = sprintf('eqn_conversion%s', $i);
      $conversions[$varname] = array('original'=>$im, 'converted'=>$converted);
      $replace = str_replace($im, $varname, $fm);
      $rhs = str_replace($fm, $replace, $rhs);
    }

    // replace brackets with parens
    $rhs = str_replace('{', '(', $rhs);
    $rhs = str_replace('}', ')', $rhs);

    // actually do the conversion
    $rhs_str = $this->toLisp($rhs);
    
    // fill in the old functions
    foreach($conversions as $name=>$conv) {
      $rhs_str = str_replace(sprintf('"%s"', $name), $conv['converted'], $rhs_str);
    }

    // replace the conditionals with the appropriate lisp functions
    foreach($lisp_mappings as $k=>$v) {
      $rhs_str = str_replace($k, $v, $rhs_str);
    }

    // do a couple of replacements to handle the distance equation
    preg_match_all('/\(expt \(- "(\w|\.)+"\s\d+\s"(\w|\.)+"\)/', $rhs_str, $exp_matches);
    foreach($exp_matches[0] as $match) {
      preg_match('/\s\d\s/', $match, $num);
      $num = $num[0];      
      $rmatch = str_replace($num, ' ', $match);
      $rmatch .= $num . ')';
      $rhs_str = str_replace($match, $rmatch, $rhs_str);
    }
    $rhs_str = str_replace(' ))))) ', '))) ', $rhs_str);

    // one last replacement should do the trick
    // (< (sqrt (+ (expt 2) (- "x195.y" 1 "x196.y")

    // replace the stuff from the hidden functions
    foreach($replace_hidden as $new=>$r) {
      $str = '';
      $type = $r['type'];
      $old = $r['old'];
      preg_match('/\(.*\)/', $old, $inner);
      $inner = $inner[0];
      $inner = str_replace('(', '', $inner);
      $inner = str_replace(')', '', $inner);
      $inner = str_replace(' ','', $inner);
      $inner = explode(',', $inner);

      if($type == 'rand') {
        $first = floatval($inner[0]);
        $last = floatval($inner[1]);
        $diff = abs($first - $last);
        $min = min($first, $last);
        $str = sprintf('(+ (random %s) %s)', $diff, $min);
      } else if($type == 'max') {
        $str = sprintf('(max "%s" "%s")', $inner[0], $inner[1]);
      }
      $rhs_str = str_replace(sprintf('"%s"', $new), $str, $rhs_str);
    }

    // reverse args to subtraction
    preg_match_all('/\(-\s"[\w|\.]+"\s"[\w|\.]+"\)/', $rhs_str, $sub_matches);
    $sub_matches = $sub_matches[0];
    foreach($sub_matches as $sm) {
      $orig = $sm;
      preg_match_all('/"[\w|\.]+"/', $sm, $tokens);
      $tokens = array_reverse($tokens[0]);
      $mod = sprintf('(- %s %s)', $tokens[0], $tokens[1]);
      $rhs_str = str_replace($orig, $mod, $rhs_str);
    }

    $rhs_str = str_replace('2 ))))))', '2 ))) 1)', $rhs_str);

    return $rhs_str;
  }

  function toLisp($rhs) {
    $rhs = trim(str_replace('?', '', $rhs));
    $vars = array();
    $rparens = array();
    $output = '';
    $num_vars = 0;
    $close_function = false;
    $cond_op = false;
    $cond_op_first = null;
    
    preg_match_all('/\w+\.\w+/', $rhs, $vars);
    $translated = array();
    foreach($vars as $v) {
      foreach($v as $x) {
        if(is_numeric($x))
          continue;
        $num = preg_match('/x[0-9]+\.\w+/', $x, $matches);      
        $w = str_replace('.', '_', $x);
        $translated[$w] = $x;
        $rhs = str_replace($x, $w, $rhs);        
      }
    }

    // send it on over
    $tokens = array_reverse($this->nfx($rhs));


    $ops = array();
    $last = null;
    $divArgs = false;
    // prepare tokens in order to reverse arguments to division
    foreach($tokens as $i=>$t) {
      $num = preg_match('/\W+/', $t);
      $tok = trim($t);
      if($num > 0) {
        if($tok == '/') {
          $divArgs = true;
        } else if($divArgs == true) {
          if(sizeof($ops) >= 2)
            break;
          $ops[] = array($tok=>array());
          $last = $tok;
        }
      } else if($divArgs == true) {
        $ops[sizeof($ops)-1][$last][] = $tok;
      }
    }
    if($divArgs == true) {
      $ops = array_reverse($ops);
      $r_tokens = array('/');
      foreach($ops as $o) {
        foreach($o as $i=>$p) {
          $r_tokens[] = $i;
          foreach($p as $s)
            $r_tokens[] = $s;
        }
      }
      $tokens = $r_tokens;
    }

    foreach($tokens as $i=>$t) {
      $is_op = (preg_match('/\W/', $t) === 1 && strlen($t) == 1);
      if($is_op) {
        if($t == '>' || $t == '<' || $t == '&' || $t == '%' || $t == '^') 
          $cond_op = true;
        $num_vars = 0;
        $output .= sprintf('(%s ', $t);
        $rparens[] = ')';
      } else {
        if($t == '_') {
          $output .= '-';
          continue;
        } else if (strrpos($t, '(') != false) {
          // it's a function!
          $func = str_replace('(', '', $t);
          $output .= sprintf('(%s ', $func);
          $close_function = true;
          continue;
        } else if ($cond_op == true && $cond_op_first == null) {
          $cond_op_first = $t;
          continue;
        }
        $num_vars++;
        if(isset($translated[$t]))
          $t = $translated[$t];
        // $t = preg_replace('/_/', '.', $t, 1);
        if(!is_numeric($t))
          $t = sprintf('"%s"', $t);
        if($num_vars == 2) {
          $num_vars = 0;
          $output .= sprintf('%s%s', $t, array_pop($rparens));
        } else {
          $output .= sprintf('%s', $t);
          if(!$close_function)
            $output .= ' ';
        }        
        if($close_function) {
          $output .= ') ';
          $close_function = false;
        } else if ($cond_op == true && $cond_op_first != null) {
          $cond_op_first = preg_replace('/_/', '.', $cond_op_first, 1);
          if(!is_numeric($cond_op_first))
            $cond_op_first = sprintf('"%s"', $cond_op_first);
          if($num_vars == 2) {
            $num_vars = 0;
            $output .= sprintf('%s%s', $cond_op_first, array_pop($rparens));
          } else {
            $output .= sprintf('%s', $cond_op_first);
            if(!$close_function)
              $output .= ' ';
          }          
          $cond_op = false;
          $cond_op_first = null;
        }
      }
    }

    $output .= join('', $rparens);
    $output = str_replace(') )', '))', trim($output));
    return $output;
  }
    
  function EvalMath() {
    // make the variables a little more accurate
    $this->v['pi'] = pi();
    $this->v['e'] = exp(1);
  }
    
  function e($expr) {
    return $this->evaluate($expr);
  }
    
  function evaluate($expr) {
    $this->last_error = null;
    $expr = trim($expr);
    if (substr($expr, -1, 1) == ';') $expr = substr($expr, 0, strlen($expr)-1); // strip semicolons at the end
    //===============
    // is it a variable assignment?
    if (preg_match('/^\s*([a-z]\w*)\s*=\s*(.+)$/', $expr, $matches)) {
      if (in_array($matches[1], $this->vb)) { // make sure we're not assigning to a constant
        return $this->trigger("cannot assign to constant '$matches[1]'");
      }
      if (($tmp = $this->pfx($this->nfx($matches[2]))) === false) return false; // get the result and make sure it's good
      $this->v[$matches[1]] = $tmp; // if so, stick it in the variable array
      return $this->v[$matches[1]]; // and return the resulting value
      //===============
      // is it a function assignment?
    } elseif (preg_match('/^\s*([a-z]\w*)\s*\(\s*([a-z]\w*(?:\s*,\s*[a-z]\w*)*)\s*\)\s*=\s*(.+)$/', $expr, $matches)) {
      $fnn = $matches[1]; // get the function name
      if (in_array($matches[1], $this->fb)) { // make sure it isn't built in
        return $this->trigger("cannot redefine built-in function '$matches[1]()'");
      }
      $args = explode(",", preg_replace("/\s+/", "", $matches[2])); // get the arguments
      if (($stack = $this->nfx($matches[3])) === false) return false; // see if it can be converted to postfix
      for ($i = 0; $i<count($stack); $i++) { // freeze the state of the non-argument variables
        $token = $stack[$i];
        if (preg_match('/^[a-z]\w*$/', $token) and !in_array($token, $args)) {
          if (array_key_exists($token, $this->v)) {
            $stack[$i] = $this->v[$token];
          } else {
            return $this->trigger("undefined variable '$token' in function definition");
          }
        }
      }
      $this->f[$fnn] = array('args'=>$args, 'func'=>$stack);
      return true;
      //===============
    } else {
      return $this->pfx($this->nfx($expr)); // straight up evaluation, woo
    }
  }
    
  function vars() {
    $output = $this->v;
    unset($output['pi']);
    unset($output['e']);
    return $output;
  }
    
  function funcs() {
    $output = array();
    foreach ($this->f as $fnn=>$dat)
      $output[] = $fnn . '(' . implode(',', $dat['args']) . ')';
    return $output;
  }

  //===================== HERE BE INTERNAL METHODS ====================\\

  // Convert infix to postfix notation
  function nfx($expr) {
    
    $index = 0;
    $stack = new EvalMathStack;
    $output = array(); // postfix form of expression, to be passed to pfx()
    $expr = trim(strtolower($expr));
        
    $ops   = array('+', '-', '*', '/', '^', '_', '<', '>', '&', '%', '=');
    $ops_r = array('+'=>0,'-'=>0,'*'=>0,'/'=>0,'^'=>1, '<'=>1, '>'=>1, 
                   '&'=>1, '%'=>1, '='=>0); // right-associative operator?  
    $ops_p = array('+'=>0,'-'=>0,'*'=>1,'/'=>1,'_'=>1,'^'=>2, '<'=>3, '>'=>3,
                   '&'=>3, '%'=>3, '='=>3); // operator precedence
        
    $expecting_op = false; // we use this in syntax-checking the expression
    // and determining when a - is a negation
    
    if (preg_match("/[^\w\s+*^\/()\.,-<>=\#\&%]/", $expr, $matches)) { // make sure the characters are all good
      return $this->trigger("illegal character '{$matches[0]}'");
    }
    
    while(1) { // 1 Infinite Loop ;)
      $op = substr($expr, $index, 1); // get the first character at the current index
      // find out if we're currently at the beginning of a number/variable/function/parenthesis/operand
      $ex = preg_match('/^([a-z]\w*\(?|\d+(?:\.\d*)?|\.\d+|\()/', substr($expr, $index), $match);
      //===============
      if ($op == '-' and !$expecting_op) { // is it a negation instead of a minus?
        $stack->push('_'); // put a negation on the stack
        $index++;
      } elseif ($op == '_') { // we have to explicitly deny this, because it's legal on the stack 
        return $this->trigger("illegal character '_'"); // but not in the input expression
        //===============
      } elseif ((in_array($op, $ops) or $ex) and $expecting_op) { // are we putting an operator on the stack?
        if ($ex) { // are we expecting an operator but have a number/variable/function/opening parethesis?
          $op = '*'; $index--; // it's an implicit multiplication
        }
        // heart of the algorithm:
        while($stack->count > 0 and ($o2 = $stack->last()) and in_array($o2, $ops) and ($ops_r[$op] ? $ops_p[$op] < $ops_p[$o2] : $ops_p[$op] <= $ops_p[$o2])) {
          $output[] = $stack->pop(); // pop stuff off the stack into the output
        }
        // many thanks: http://en.wikipedia.org/wiki/Reverse_Polish_notation#The_algorithm_in_detail
        $stack->push($op); // finally put OUR operator onto the stack
        $index++;
        $expecting_op = false;
        //===============
      } elseif ($op == ')' and $expecting_op) { // ready to close a parenthesis?
        while (($o2 = $stack->pop()) != '(') { // pop off the stack back to the last (
          if (is_null($o2)) return $this->trigger("unexpected ')'");
          else $output[] = $o2;
        }
        if (preg_match("/^([a-z]\w*)\($/", $stack->last(2), $matches)) { // did we just close a function?
          $fnn = $matches[1]; // get the function name
          $arg_count = $stack->pop(); // see how many arguments there were (cleverly stored on the stack, thank you)
          $output[] = $stack->pop(); // pop the function and push onto the output
          if (in_array($fnn, $this->fb)) { // check the argument count
            if($arg_count > 1)
              return $this->trigger("too many arguments ($arg_count given, 1 expected)");
          } elseif (array_key_exists($fnn, $this->f)) {
            if ($arg_count != count($this->f[$fnn]['args']))
              return $this->trigger("wrong number of arguments ($arg_count given, " . count($this->f[$fnn]['args']) . " expected)");
          } else { // did we somehow push a non-function on the stack? this should never happen
            return $this->trigger("internal error");
          }
        }
        $index++;
        //===============
      } elseif ($op == ',' and $expecting_op) { // did we just finish a function argument?
        while (($o2 = $stack->pop()) != '(') { 
          if (is_null($o2)) return $this->trigger("unexpected ','"); // oops, never had a (
          else $output[] = $o2; // pop the argument expression stuff and push onto the output
        }
        // make sure there was a function
        if (!preg_match("/^([a-z]\w*)\($/", $stack->last(2), $matches))
          return $this->trigger("unexpected ','");
        $stack->push($stack->pop()+1); // increment the argument count
        $stack->push('('); // put the ( back on, we'll need to pop back to it again
        $index++;
        $expecting_op = false;
        //===============
      } elseif ($op == '(' and !$expecting_op) {
        $stack->push('('); // that was easy
        $index++;
        $allow_neg = true;
        //===============
      } elseif ($ex and !$expecting_op) { // do we now have a function/variable/number?
        $expecting_op = true;
        $val = $match[1];
        if (preg_match("/^([a-z]\w*)\($/", $val, $matches)) { // may be func, or variable w/ implicit multiplication against parentheses...
          if (in_array($matches[1], $this->fb) or array_key_exists($matches[1], $this->f)) { // it's a func
            $stack->push($val);
            $stack->push(1);
            $stack->push('(');
            $expecting_op = false;
          } else { // it's a var w/ implicit multiplication
            $val = $matches[1];
            $output[] = $val;
          }
        } else { // it's a plain old var or num
          $output[] = $val;
        }
        $index += strlen($val);
        //===============
      } elseif ($op == ')') { // miscellaneous error checking
        return $this->trigger("unexpected ')'");
      } elseif (in_array($op, $ops) and !$expecting_op) {
        return $this->trigger("unexpected operator '$op'");
      } else { // I don't even want to know what you did to get here
        return $this->trigger("an unexpected error occured");
      }
      if ($index == strlen($expr)) {
        if (in_array($op, $ops)) { // did we end with an operator? bad.
          return $this->trigger("operator '$op' lacks operand");
        } else {
          break;
        }
      }
      while (substr($expr, $index, 1) == ' ') { // step the index past whitespace (pretty much turns whitespace 
        $index++;                             // into implicit multiplication if no operator is there)
      }
        
    } 
    while (!is_null($op = $stack->pop())) { // pop everything off the stack and push onto output
      if ($op == '(') {
        return $this->trigger("expecting ')'"); // if there are (s on the stack, ()s were unbalanced
      }
      $output[] = $op;
    }
    return $output;
  }

  // evaluate postfix notation
  function pfx($tokens, $vars = array()) {
        
    if ($tokens == false) return false;
    
    $stack = new EvalMathStack;
        
    foreach ($tokens as $token) { // nice and easy
      // if the token is a binary operator, pop two values off the stack, do the operation, and push the result back on
      if (in_array($token, array('+', '-', '*', '/', '^'))) {
        if (is_null($op2 = $stack->pop())) return $this->trigger("internal error");
        if (is_null($op1 = $stack->pop())) return $this->trigger("internal error");
        switch ($token) {
        case '+':
          $stack->push($op1+$op2); break;
        case '-':
          $stack->push($op1-$op2); break;
        case '*':
          $stack->push($op1*$op2); break;
        case '/':
          if ($op2 == 0) return $this->trigger("division by zero");
          $stack->push($op1/$op2); break;
        case '^':
          $stack->push(pow($op1, $op2)); break;
        }
        // if the token is a unary operator, pop one value off the stack, do the operation, and push it back on
      } elseif ($token == "_") {
        $stack->push(-1*$stack->pop());
        // if the token is a function, pop arguments off the stack, hand them to the function, and push the result back on
      } elseif (preg_match("/^([a-z]\w*)\($/", $token, $matches)) { // it's a function!
        $fnn = $matches[1];
        if (in_array($fnn, $this->fb)) { // built-in function:
          if (is_null($op1 = $stack->pop())) return $this->trigger("internal error");
          $fnn = preg_replace("/^arc/", "a", $fnn); // for the 'arc' trig synonyms
          if ($fnn == 'ln') $fnn = 'log';
          eval('$stack->push(' . $fnn . '($op1));'); // perfectly safe eval()
        } elseif (array_key_exists($fnn, $this->f)) { // user function
          // get args
          $args = array();
          for ($i = count($this->f[$fnn]['args'])-1; $i >= 0; $i--) {
            if (is_null($args[$this->f[$fnn]['args'][$i]] = $stack->pop())) return $this->trigger("internal error");
          }
          $stack->push($this->pfx($this->f[$fnn]['func'], $args)); // yay... recursion!!!!
        }
        // if the token is a number or variable, push it on the stack
      } else {
        if (is_numeric($token)) {
          $stack->push($token);
        } elseif (array_key_exists($token, $this->v)) {
          $stack->push($this->v[$token]);
        } elseif (array_key_exists($token, $vars)) {
          $stack->push($vars[$token]);
        } else {
          return $this->trigger("undefined variable '$token'");
        }
      }
    }
    // when we're out of tokens, the stack should have a single element, the final result
    if ($stack->count != 1) return $this->trigger("internal error");
    return $stack->pop();
  }
    
  // trigger an error, but nicely, if need be
  function trigger($msg) {
    $this->last_error = $msg;
    if (!$this->suppress_errors) trigger_error($msg, E_USER_WARNING);
    return false;
  }
}

// for internal use
class EvalMathStack {

    var $stack = array();
    var $count = 0;
    
    function push($val) {
        $this->stack[$this->count] = $val;
        $this->count++;
    }
    
    function pop() {
        if ($this->count > 0) {
            $this->count--;
            return $this->stack[$this->count];
        }
        return null;
    }
    
    function last($n=1) {
      if($this->count >= $n)
        return $this->stack[$this->count-$n];
    }
}

?>