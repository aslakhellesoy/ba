document.observe('dom:loaded', function() {
  when('page_class_name', function(select) {
    if($F('page_class_name') == 'HappeningPage' && $('edit_page_happening'))
      $('edit_page_happening').show().select('select').invoke('enable');

    if($('edit_page_happening')) {
      select.observe('change', function(){
        if($F(this) == 'HappeningPage')
          $('edit_page_happening').show().select('select').invoke('enable');
        else
          $('edit_page_happening').hide().select('select').invoke('disable');
      });
    } else {
      select.observe('change', function(){
        if($F(this) == 'HappeningPage')
          alert("You must save the page in order to see the Happening fields.");
      });
    }
  });
});