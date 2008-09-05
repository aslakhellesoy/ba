class Admin::ProgramController < Admin::AbstractModelController
  model_class ProgramPage
  
  def edit
    @program_page = ProgramPage.find_by_id(params[:id])
    @presentations = @program_page.presentation_pages
    @program_page.layout = edit_layout
    @program_page.process(request, response)
    @performed_render = true
  end
  
  def edit_layout
    Layout.new :name => 'Program Edit', :content_type => 'text/html', :content => %{
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<head>
  <title>Edit <r:title /></title>
  <link rel="stylesheet" type="text/css" href="/stylesheets/admin/main.css" />
  <script type="text/javascript">
    var form_authenticity_token = "#{form_authenticity_token}";
  </script>
  <script src="/javascripts/prototype.js" type="text/javascript"></script>
  <script src="/javascripts/effects.js" type="text/javascript"></script>
  <script src="/javascripts/dragdrop.js" type="text/javascript"></script>
  <script src="/javascripts/admin/edit_program.js" type="text/javascript"></script>
  <style type="text/css">
.slot_hover {
  background: #FFCC66;
}

div.empty {
  background: pink;
}

div#DRAFT {
  min-height: 30px;
}

  </style>
</head>
<body>
  <div id="page">
    <div id="header">
      <div id="site-title">Edit <r:title /></div>
      <div id="site-subtitle">Just drag presentation onto the slots...</div>
    </div>
    <div id="main">
      <div id="content-wrapper">
        <div id="content">
          <h1><r:title /></h1>
          <r:content />
        </div>
      </div>
    </div>
    <hr class="hidden" />
    <div id="footer">
      <p>Presentations that are not in the program (drafts)</p>
      <div class="slot" id="DRAFT">
        <r:ba:presentations:each_draft>
          <div class="presentation" id="presentation_<r:id />">
            <r:snippet name="presentation"/>
          </div>
        </r:ba:presentations:each_draft>
      </div>
    </div>
  </div>
</body>
</html>}

  end
end