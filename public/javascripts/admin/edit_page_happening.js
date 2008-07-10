document.observe('dom:loaded', function() {
  when('page_class_name', function(select) {
    if($F('page_class_name') == 'HappeningPage')
	  $('edit_page_happening').show().select('select').invoke('enable');
	
    select.observe('change', function(){
      if($F(this) == 'HappeningPage')
        $('edit_page_happening').show().select('select').invoke('enable');
      else
        $('edit_page_happening').hide().select('select').invoke('disable');
    })
  });
});