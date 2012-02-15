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
        var table = loadSimData(variables[i]);
        console.log(table);
        $('#simulation-data').append(table);
      }
    });
  }

  function loadSimData(data) {
    var table = $('<table />').attr('id', 'simulation-data-' + data.id);
    var header = $('<tr />');
    var row = $('<tr />');
    var name = data.entity_name;
    for(var i in data) {
      if(i == 'entity_name' || i == 'id')
        continue;
      th = $('<th />').html(name + '.' + i);
      td = $('<td />').html(data[i]);
      header.append(th);
      row.append(td);
    }
    table.append(header).append(row);
    return table;
  }

  grabExogenousData();
});