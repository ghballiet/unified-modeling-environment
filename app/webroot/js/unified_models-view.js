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
       $(this).attr('id') == 'EmpiricalObservationValue')
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
        row.push(values[i][j]);
        row.push(empirical_data[i][j]);
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

  grabExogenousData();
  genericProcessArgs();
  concreteProcessArgs();
});