document.observe('dom:loaded', function() {
  when('page_class_name', function(select) {
    if($F('page_class_name') == 'HappeningPage' && $('edit_page_happening'))
      $('edit_page_happening').show().select('select').invoke('enable');

    if($('edit_page_happening')) {
      select.observe('change', function(){
        if($F(this) == 'HappeningPage') {
          $('edit_page_happening').show().select('select').invoke('enable');
          alert("Click \"Save and Continue Editing\" before adding any parts. This will the required parts for you with default contentt.");
        } else {
          $('edit_page_happening').hide().select('select').invoke('disable');
        }
      });
    } else {
      select.observe('change', function(){
        if($F(this) == 'HappeningPage')
          alert("You can *not* change an existing page to Happening. Create a new page instead.");
      });
    }
  });
});