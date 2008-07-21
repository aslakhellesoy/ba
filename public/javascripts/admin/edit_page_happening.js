document.observe('dom:loaded', function() {
  when('page_class_name', function(select) {
    if($F('page_class_name') == 'HappeningPage' && $('edit_page_happening'))
      $('edit_page_happening').show().select('select').invoke('enable');

    if($('edit_page_happening')) {
      select.observe('change', function(){
        if($F(this) == 'HappeningPage') {
          $('edit_page_happening').show().select('select').invoke('enable');
          alert("Save the page before adding any parts. Then edit it again. It will have the special parts auto created with default content.");
        } else {
          $('edit_page_happening').hide().select('select').invoke('disable');
        }
      });
    } else {
      select.observe('change', function(){
        if($F(this) == 'HappeningPage')
          alert("It's strongly recommended that you do not change an existing page to Happening. Create a new page instead.");
      });
    }
  });
});