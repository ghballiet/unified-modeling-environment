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
});