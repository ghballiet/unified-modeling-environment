$(document).ready(function() {
  $('a.deleteModel').live('click', function(e) {
    e.preventDefault();
    var url = $(this).attr('data-delete-url');
    var goAhead = confirm('Are you sure you want to delete this model? This CANNOT be undone.');
    if(goAhead)
      window.location = url;
  });
  
  $('a.expand').toggle(function() {
    var container = $('#' + $(this).attr('data-expand-id'));
    var source = $('#' + container.attr('data-expand-id'));
    var attrs = source.find('div.generic-attribute');
    container.html(attrs.clone());
    container.find('a.btnDelete').remove();
    container.fadeIn('fast');
    $(this).html('&#x25b2;');
  }, function() {
    var container = $('#' + $(this).attr('data-expand-id'));
    container.hide();
    $(this).html('&#x25bc;');
  });

  // always replace spaces with underscores
  $('input[type="text"], textarea').live('keypress', function(e) {
    if($(this).attr('id') == 'ConcreteEquationRightHandSide' || $(this).attr('id') == 'GenericEquationRightHandSide')
      return true;
    if(e.keyCode == 32) {
      e.preventDefault();
      var val = $(this).val() + '_';
      $(this).val(val);
    } else {
      var str = String.fromCharCode(e.keyCode);
      if(str.match(/\W/g) != null && str != '.')
	e.preventDefault();
    }
  });

  // grab the exogenous data
  function grabExogenousData() {
    var url = $('#data-url').val();
    $.post(url, {}, function(data) {
      eval(data);
      console.log('Simulation data loaded.');
      console.log('Variables: ', variables);
      for(var i in variables) {
        createRows(variables[i]);
      }
    });
  }

  function createRows(data) {
    var name = data.entity_name;
    for(var i in data) {
      if(i == 'id' || i == 'entity_name')
        continue;
      var row = $('<tr />');
      var spanName = $('<span />').addClass('name').html(name);
      var spanAttr = $('<span />').addClass('attr').html(i);
      var tdName = $('<td />').addClass('name').append(spanName).append('.').append(spanAttr);
      var tdValue = $('<td />').addClass('value').html(data[i]);
      row.append(tdName).append(tdValue);
      $('#simulation-data tbody').append(row);
    }
  }

  function genericProcessArgs() {
    $('#GenericProcessNumArguments').change(function() {
      var num = parseInt($(this).val()) + 1;
      var i = 0;
      $('div.input.hidden').hide();
      for(i=1; i<=num; i++) {
        $('#arg_' + i).show();
      }
    });
  }

  function concreteProcessArgs() {
    // load the initial set
    var gp = $('#ConcreteProcessGenericProcessId').val();
    loadConcreteProcessArgs(gp);

    $('#ConcreteProcessGenericProcessId').change(function() {
      loadConcreteProcessArgs($(this).val());
    });
  }

  function loadConcreteProcessArgs(id) {
    var cpa = concrete_process_argument_list;
    var count = 0;
    $('#ConcreteProcessArguments').html('');
    for(var i in cpa[id]) {
      count++;
      var arg = cpa[id][i];
      var div = $('<div />').addClass('input select');
      var num = parseInt(i)+1;
      var lbl = $('<label />').html('Argument ' + num);
      var select = $('<select />').attr('name', 'data[ConcreteProcess][argument-' + i + ']');
      for(var j in arg) {
        var opt = $('<option />').val(j).html(arg[j]);
        select.append(opt);
      }
      div.append(lbl).append(select);
      $('#ConcreteProcessArguments').append(div);
    }
    $('#ConcreteProcessNumArguments').val(count);
  }

  grabExogenousData();
  genericProcessArgs();
  concreteProcessArgs();
});