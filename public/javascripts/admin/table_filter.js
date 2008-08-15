/* Adds filter logic to a table. The table must have input fields in table headers.
 * @author Aslak Hellesøy
 */
Element.Methods.filterize = function(table) {
  var filters = table.getElementsBySelector("th input.filter");

  var hideRows = function(observedFilter, value) {
    table.select("tbody tr").each(function(tr) {
      var matches = filters.map(function(filter) {
        var filterValue = filter.value.toUpperCase();
        var filterTd = filter.up();
        var filterCol = filterTd.up().childElements().indexOf(filterTd);
        var td = tr.select("td:nth-child(" + (filterCol+1) + ")")[0];
        return td.innerHTML.toUpperCase().include(filterValue);
      });
      var allMatching = matches.indexOf(false) == -1;
      if(allMatching) {
        tr.show();
      } else {
        tr.hide();
      }
    });
  }
  
  filters.each(function(filter) {
    new Form.Element.Observer(filter, 0.5, hideRows);
  });
};

Element.Methods.togglize = function(toggleCheckbox, form) {
  var toggleCheckbox = $(toggleCheckbox);
  var checkboxes = $(form).getInputs('checkbox').without(toggleCheckbox);
  toggleCheckbox.observe('change', function() {
    var v = toggleCheckbox.getValue();
    checkboxes.each(function(checkbox) {
      var tr = checkbox.up().up();
      if (tr.visible()) {
        checkbox.checked = v;
      }
    });
  });
}

Element.addMethods();
