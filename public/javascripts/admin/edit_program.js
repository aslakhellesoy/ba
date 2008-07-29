document.observe('dom:loaded', function() {
  $$('div.presentation').each(function(presentation){
    new Draggable(presentation, { revert: 'failure' });
  });

  var slots = $$('div.slot');
  slots.each(function(slot){
    Droppables.add(slot, {
      hoverclass: 'slot_hover',
      onDrop: function(draggable, droppable, event) {
        if(droppable.id != 'DRAFT') {
          var removed = droppable.down().remove();
          if (removed.hasClassName('presentation')) {
            $('DRAFT').appendChild(removed);
          }
        }
        
        var slot = draggable.parentNode;
        droppable.appendChild(draggable);
        draggable.style.left="0px"; 
        draggable.style.top="0px";
        if (slot.hasClassName('program')) {
          slot.innerHTML = '<div class="empty">TBA</div>';
        }
        
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