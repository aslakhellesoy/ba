document.observe('dom:loaded', function() {
  $$('div.presentation').each(function(presentation){
    new Draggable(presentation, { revert: true });
  });

  var slots = $$('div.slot');
  slots.each(function(slot){
    Droppables.add(slot, {
      hoverclass: 'slot_hover',
      onDrop: function(draggable, droppable, event) {
        var presentation_id = draggable.id.match(/presentation_(\d+)/)[1];

        var slot_match = droppable.id.match(/slot_(\d+)/);
        if(slot_match) {
          var program_slot = slot_match[1];
        } else {
          var program_slot = null;
        }

        new Ajax.Request('/admin/presentations/' + presentation_id, {
          parameters: {
            _method: 'put',
            'presentation_page[program_slot]': program_slot,
            authenticity_token: encodeURIComponent(form_authenticity_token)
          }
        });
      }
    });
  });
});