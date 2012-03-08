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
    if($(this).attr('id') == 'ConcreteEquationRightHandSide' ||
       $(this).attr('id') == 'GenericEquationRightHandSide' ||
       $(this).attr('id') == 'ExogenousValueValue' ||
       $(this).attr('id') == 'EmpiricalObservationValue' || 
       $(this).attr('name') == 'data[GenericEquation][right_hand_side]' || 
       $(this).attr('name') == 'data[ConcreteEquation][right_hand_side]' || 
       $(this).attr('id') == 'GenericConditionValue' || 
       $(this).attr('name') == 'data[GenericCondition][value]' || 
       $(this).attr('name') == 'data[ConcreteCondition][value]')
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
      console.log('Values: ', values);
      console.log('Facts: ', empirical_data);
      console.log('Simulation data loaded.');
      drawCharts(values);
      /*for(var i in values) {
        i = parseInt(i);
        createRows(i, values[i]);
      }*/
    });
  }

  function createRows(num, data) {
    var name = data.entity_name;
    for(var i in data) {
      if(i == 'id' || i == 'entity_name')
        continue;
      var row = $('<tr />');
      var spanName = $('<span />').addClass('name').html(i);
      var tdRow = $('<td />').addClass('row').html(num);
      var tdName = $('<td />').addClass('name').append(spanName);
      var tdValue = $('<td />').addClass('value').html(data[i]);
      row.append(tdRow).append(tdName).append(tdValue);
      $('#simulation-data tbody').append(row);
    }
  }

  function drawCharts(values) {
    // we're gonna do this with arrays
    var data = {};
    // build the initial rows
    for(var i in values[0]) {
      var table = new google.visualization.DataTable();
      table.addColumn('number', 'Time');
      table.addColumn('number', 'Simulated');
      table.addColumn('number', 'Observed');
      data[i] = table;    
    }
    // build the rest of the data tables
    for(var i in values) {
      for(var j in values[i]) {
        var row = [];
        row.push(parseInt(i));
        var v = values[i][j];
        // variables which appear on the left hand side of an equation
        // get graphed as simulated data, not observed
        if($.inArray(j, lhs_variables) == -1) {
          row.push(empirical_data[i][j]);
          row.push(parseFloat(v.toFixed(2)));
        } else {
          row.push(parseFloat(v.toFixed(2)));
          row.push(empirical_data[i][j]);
        }
        data[j].addRows([row]);
      }
    }
    var width = $('#right').width();
    for(var i in data) {
      var options = {
        width: width, height: 100, title: i, fontSize: 10, fontName: 'Helvetica, Arial',
        legend: { position: 'bottom' }
      };
      var id = i.toLowerCase().replace(/\./g, '-').replace(/_/g, '-');      
      var div = $('<div />').attr('id', 'chart-' + id).addClass('google-chart');
      $('#google-chart').append(div);
      var chart = new google.visualization.LineChart(document.getElementById('chart-' + id));
      chart.draw(data[i], options);
      // build the radio box
      var chk = $('<input >').attr({
        type: 'checkbox',
        name: i,
        id: 'chk-' + id,
        checked: true,
        'data-show-id': 'chart-' + id
      }).addClass('chk-data-select');
      var lbl = $('<label />').attr('for', 'chk-' + id);
      lbl.html(i);
      var wrap = $('<div />').addClass('data-select').append(chk).append(lbl);
      $('#data-selection').append(wrap);
    }

    $('input.chk-data-select').live('change', function() {
      var id = $(this).attr('data-show-id');
      if($(this).is(':checked'))
        $('#' + id).show('fast');
      else
        $('#' + id).hide('fast');
    });
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

  function setupEditEvents() {
    $('div.concrete-process-attribute').click(function() { $(this).editConcreteProcessAttribute(); });
    $('div.concrete-attribute').click(function() { $(this).editConcreteAttribute(); });
    $('div.concrete-equation').click(function() { $(this).editConcreteEquation(); });
    $('div.generic-process-attribute').click(function() { $(this).editGenericProcessAttribute(); });
    $('div.generic-equation').click(function() { $(this).editGenericEquation(); });
    $('div.generic-attribute').click(function() { $(this).editGenericAttribute(); });
    $('span.generic-condition').click(function() { $(this).editGenericCondition(); });
  }

  function showModal(map) {
    var div = $('<div />').addClass('reveal-modal').addClass(map.controller);
    var title = $('<h1 />').html(map.title);
    var close = $('<a />').html('&#215;').addClass('close-reveal-modal').attr('href','#');
    var form = $('<form />').attr({
      method: 'post',
      action: '../../' + map.controller + '/edit/' + map.fields.id.value
    });
    div.append(close).append(title).append(form);
    $('#content').prepend(div);
    for(var i in map.fields) {
      var field = map.fields[i];
      var row = $('<div />').addClass('input').addClass(field.type);
      var lbl = $('<label />').html(field.label);
      var input = $('<input >').attr({
        type: field.type,
        name: 'data[' + map.type + '][' + i + ']'
      }).val(field.value);
      row.append(lbl).append(input);
      form.append(row);
    }
    var subDiv = $('<div />').addClass('submit');
    var submit = $('<input >').attr('type', 'submit').val('Save');
    subDiv.html(submit);
    form.append(subDiv);
    div.reveal();
  }

  // ---- extension functions here ----  
  $.fn.editGenericCondition = function() {
    var attr = $(this).attr('id');
    var type = 'generic-condition';
    var id = parseInt(attr.replace(type + '-', ''));
    var value = $(this).text();
    var modelId = parseInt(model.UnifiedModel.id);
    var map = {
      type: 'GenericCondition',
      title: 'Edit Generic Process Condition',
      controller: 'generic_conditions',
      fields: {
        id: { label: '', type: 'hidden', value: id },
        value: { label: 'Value', type: 'text', value: value },
        unified_model_id: { label: '', type: 'hidden', value: modelId }
      }
    };
    showModal(map);
    var delLink = $('<a />').addClass('btnDelete').html('Delete Condition');
    delLink.attr('href', '../../' + map.controller + '/delete/' + id + '/' + modelId);
    $('div.reveal-modal.generic_conditions').append(delLink);
  };

  $.fn.editConcreteProcessAttribute = function() {
    var attr = $(this).attr('id');
    var type = $(this).attr('class');
    var id = parseInt(attr.replace(type + '-', ''));
    var name = $(this).find('span.name').html();
    var value = $(this).find('span.value').html();
    var modelId = parseInt(model.UnifiedModel.id);
    var map = {
      type: 'ConcreteProcessAttribute', 
      title: 'Edit Concrete Process Attribute',
      controller: 'concrete_process_attributes',
      fields: {
        id: { label: '', type: 'hidden', value: id },
        name: { label: 'Name', type: 'text', value: name },
        value: { label: 'Value', type: 'text', value: value },
        unified_model_id: { label: '', type: 'hidden', value: modelId }
      }
    };
    showModal(map);
  };

  $.fn.editGenericAttribute = function() {
    var attr = $(this).attr('id');
    var type = $(this).attr('class');
    var id = parseInt(attr.replace(type + '-', ''));
    var name = $(this).find('span.name').html();
    var value = $(this).find('span.value').html();
    var modelId = parseInt(model.UnifiedModel.id);
    var map = {
      type: 'GenericAttribute',
      title: 'Edit Generic Attribute',
      controller: 'generic_attributes',
      fields: {
        id: { label: '', type: 'hidden', value: id },
        name: { label: 'Name', type: 'text', value: name },
        value: { label: 'Value', type: 'text', value: value },
        unified_model_id: { label: '', type: 'hidden', value: modelId }
      }
    };
    showModal(map);
  };
    

  $.fn.editGenericEquation = function() {
    var attr = $(this).attr('id');
    var type = $(this).attr('class');
    var id = parseInt(attr.replace(type + '-', ''));
    var name = $(this).find('span.name').html();
    var value = $(this).find('span.value').html();
    var modelId = parseInt(model.UnifiedModel.id);
    var map = {
      type: 'GenericEquation',
      title: 'Edit Generic Equation', 
      controller: 'generic_equations',
      fields: {
        id: { label: '', type: 'hidden', value: id },
        right_hand_side: { label: 'Right Hand Side', type: 'text', value: value },
        unified_model_id: { label: '', type: 'hidden', value: modelId }
      }
    };
    showModal(map);
  };

  $.fn.editGenericProcessAttribute = function() {
    var attr = $(this).attr('id');
    var type = $(this).attr('class');
    var id = parseInt(attr.replace(type + '-', ''));
    var name = $(this).find('span.name').html();
    var value = $(this).find('span.value').html();
    var modelId = parseInt(model.UnifiedModel.id);
    var map = {
      type: 'GenericProcessAttribute',
      title: 'Edit Generic Process Attribute',
      controller: 'generic_process_attributes',
      fields: {
        id: { label: '', type: 'hidden', value: id },
        name: { label: 'Name', type: 'text', value: name },
        value: { label: 'Value', type: 'text', value: value },
        unified_model_id: { label: '', type: 'hidden', value: modelId }
      }
    };
    showModal(map);
  };

  $.fn.editConcreteAttribute = function() {
    var attr = $(this).attr('id');
    var type = $(this).attr('class');
    var id = parseInt(attr.replace(type + '-', ''));
    var name = $(this).find('span.name').html();
    var value = $(this).find('span.value').html();
    var modelId = parseInt(model.UnifiedModel.id);
    var map = {
      type: 'ConcreteAttribute',
      title: 'Edit Concrete Attribute',
      controller: 'concrete_attributes', 
      fields: {
        id: { label: '', type: 'hidden', value: id },
        name: { label: 'Name', type: 'text', value: name },
        value: { label: 'Value', type: 'text', value: value },
        unified_model_id: { label: '', type: 'hidden', value: modelId }
      }
    };
    showModal(map);
  }

  $.fn.editConcreteEquation = function() {
    var attr = $(this).attr('id');
    var type = $(this).attr('class');
    var id = parseInt(attr.replace(type + '-', ''));
    var name = $(this).find('span.name') + '.' + $(this).find('span.attr').html();
    console.log($(this));
    var rhs = $(this).find('span.value').html();
    var modelId = parseInt(model.UnifiedModel.id); 
    var map = {
      type: 'ConcreteEquation',
      title: 'Edit Concrete Equation',
      controller: 'concrete_equations',
      fields: {
        id: { label: '', type: 'hidden', value: id },
        right_hand_side: { label: 'Right Hand Side', type: 'text', value: rhs },
        unified_model_id: { label: '', type: 'hidden', value: modelId }
      }
    };
    showModal(map);
  };

  // ---- simulate click event! ----
  $('#btnSimulate').click(function(e) {
    e.preventDefault();
    var id = model.UnifiedModel.id;
    var url = '../simulate_lisp/' + id;

    $('#simulating-msg').reveal({closeonbackgroundclick: false});

    // set up the exogenous values
    ex_values = exogenous_values.ExogenousValue.value;
    lines = ex_values.split("\n");

    var rows = {};
    rows['values'] = {};
    for(var i in lines) {
      var line = lines[i];
      if(i==0)
        rows['names'] = line.trim().split(' ');
      else
        rows['values'][i-1] = line.trim().split(' ');
    }
    exogenous_values = rows;

    $.get(url, function(response) {
      $('#simulating-msg').trigger('reveal:close');
      console.log(response);
      eval(response);
      console.log(data);
      displaySimulationData(data);
    });
  });

  function displaySimulationData(data) {
    for(var i in data.names) {
      var name = data.names[i].toLowerCase();
      if(name == 'time')
        continue;
      var table = new google.visualization.DataTable();
      table.addColumn('number', 'time');
      table.addColumn('number', 'Simulated');
      table.addColumn('number', 'Observed');
      for(var j in data.values) {
        var val = parseFloat(data.values[j][i].replace(/d/g, 'e+'));
        var time = parseFloat(data.values[j][0].replace(/d/g, 'e+'));
        var ex = parseFloat(exogenous_values.values[j][i]);
        val = parseFloat(val.toFixed(2));
        ex = parseFloat(ex.toFixed(2));
        table.addRow([time, val, ex]);
      }
      var width = $('#right').width();
      var options = {
        width: width, height: 150, title: name, fontSize: 10, fontName: 'Helvetica, Arial',
        legend: { position: 'bottom' }
      };
      var id = name.replace(/\./g, '-').replace(/_/g, '-');
      var div = $('<div />').attr('id', 'chart-' + id).addClass('google-chart');
      $('#google-chart').append(div);
      var chart = new google.visualization.LineChart(document.getElementById('chart-' + id));
      chart.draw(table, options);
    }    
  }

  // ---- entry point ----
  // grabExogenousData();
  genericProcessArgs();
  concreteProcessArgs();
  setupEditEvents();
});