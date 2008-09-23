module BaTags
  include Radiant::Taggable

  tag "ba" do |tag|
    tag.locals.site_user = controller.current_site_user if controller && controller.respond_to?(:current_site_user)
    tag.expand
  end

  tag "ba:if_email_exists" do |tag|
    tag.expand if email_exists
  end

  tag "ba:if_logged_in" do |tag|
    if tag.locals.site_user
      tag.expand
    end
  end

  tag "ba:unless_logged_in" do |tag|
    unless tag.locals.site_user
      tag.expand
    end
  end

  tag "ba:site_user" do |tag|
    tag.expand
  end

  [:name, :email].each do |field|
    desc %{The #{field} of the currently logged in site_user.} 
    tag "ba:site_user:#{field}" do |tag|
      tag.locals.site_user.__send__(field)
    end
  end
  
  desc %{
    Renders a signup form for the happening.
    This tag can only be used on attendances/* parts of a Happening page.
    
    NOTE: If you want to automatically show/hide the presentation section in the default signup form
    you MUST make sure the layout used for your page includes the prototype.js
    javascript in the head section:
    
    <pre><code><script src="/javascripts/prototype.js" type="text/javascript"></script></code></pre>
  }
  tag "ba:signup_form" do |tag|
    result = []
    result << %{<form method="post">}
    result << %{  <input type="hidden" name="_method" value="put"/>} if @attendance && !@attendance.new_record?
    result << tag.expand
    result << "</form>"
    result
  end

  tag "ba:presentation_form" do |tag|
    url = controller.instance_eval do
      presentation_path(@presentation)
    end
    result = []
    result << %{<form action="#{url}" method="post">}
    result << %{  <input type="hidden" name="_method" value="put"/>}
    result << tag.expand
    result << "</form>"
    result
  end

  desc %{
    Renders an input field that is bound to a certain object's field/attribute/column. Handy for
    forms, because it automatically sets the value, name and id attributes of the element.
  
    *Usage:*
    <pre><code>
    <r:ba:input object="site_user" field="name" type="text">
      <span class="error"><r:error/></span>
    </r:ba:input>
    </code></pre>    

    This will render the following (if Aslak Hellesøy's signup fails):

    <pre><code>
    <input name="site_user[email]" value="Aslak Hellesøy" id="site_user_name" type="text" />
    <span class="error">has already been taken</span>
    </code></pre>
  
    Any other attributes passed to this tag will be passed on to the rendered input element.
  }
  tag "ba:input" do |tag|
    ba_input_tag(tag) do |id, object_name, field_name, field_value, attrs|
      %{<input id="#{id}" name="#{object_name}[#{field_name}]" value="#{field_value}" #{attrs} />}
    end
  end
  
  desc "See documentation for ba:input"
  tag "ba:textarea" do |tag|
    ba_input_tag(tag) do |id, object_name, field_name, field_value, attrs|
      %{<textarea id="#{id}" name="#{object_name}[#{field_name}]" #{attrs}>#{field_value}</textarea>}
    end
  end
  
  def ba_input_tag(tag)
    object_name = tag.attr.delete('object')
    field_name  = tag.attr.delete('field')
    id          = tag.attr.delete('id') || "#{object_name}_#{field_name}"
    object      = instance_variable_get("@#{object_name}")
    if object
      field_value = object.__send__(field_name)
    else
      field_value = nil
    end
    attrs = tag.attr.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    input = yield id, object_name, field_name, field_value, attrs
    result = [input]
    tag.locals.error = object.respond_to?(:errors) && object.errors.on(field_name)
    result << tag.expand if tag.locals.error
    result
  end

  [:input, :textarea].each do |f|
    desc "Renders the error of an #{f} field"
    tag "ba:#{f}:error" do |tag|
      tag.locals.error
    end
  end
  
  desc %{
    Expands the radius tag if the presentation being edited is tagged with a certain meta tag.
    
    Usage: <pre><code><r:if_has_tag tag="fruits">...</r:if_has_tag></code></pre>
  }
  tag "if_has_tag" do |tag|
    if @presentation && @presentation.tag_list.index(tag.attr['tag'])
      tag.expand
    end
  end

  desc "List the current page's tags (without links)"
  tag "tags" do |tag|
    tag.locals.page.tag_list
  end

  desc "Iterate over current page's meta tags"
  tag "each_tag" do |tag|
    result = []
    tag.locals.page.tag_list.split(" ").each do |meta_tag|
      tag.locals.meta_tag = meta_tag
      result << tag.expand
    end
    result
  end

  desc "Current meta tag"
  tag "each_tag:meta_tag" do |tag|
    tag.locals.meta_tag
  end

  [:signup_page, :edit_presentation_page, :attendance_page].each do |p|
    desc "Makes the happening's #{p} the current page"
    tag "ba:#{p}" do |tag|
      tag.locals.page = happening_page.__send__ p
      tag.expand
    end
  end

  desc %{
    Tags inside this tag refer to the attendance of the current site_user.
  }
  tag "ba:attendance" do |tag|
    tag.locals.attendance = happening_page.attendance(tag.locals.site_user)
    tag.expand
  end

  desc %{
    Renders the contained elements only if the current site_user has NOT signed up for the happening
  }
  tag "ba:attendance:unless" do |tag|
    tag.expand unless tag.locals.attendance
  end

  desc %{
    Renders the contained elements only if the current site_user has signed up for the happening
  }
  tag "ba:attendance:if" do |tag|
    tag.expand if tag.locals.attendance
  end

  desc %{
    Renders the price (currency and amount) of the signed in site_user's attendance
    to the happening.
    
    *Usage:* 
    <pre><code><r:ba:attendance:price [free="free_text"]/></code></pre>
  }
  tag "ba:attendance:price" do |tag|
    price = tag.locals.attendance.actual_price
    free = tag.attr['free'] || '0'
    price ? "#{price.currency} #{price.amount}" : free
  end

  desc %{
    Tags inside this tag refer to the presentations of the current site_user, relative to the happening.
  }
  tag "ba:attendance:presentations" do |tag|
    if tag.locals.attendance
      tag.locals.presentation_pages = tag.locals.attendance.presentation_pages
      tag.expand
    end
  end

  desc %{
    Renders the contained elements only if the current site_user has NOT submitted any presentations
  }
  tag "ba:attendance:presentations:unless" do |tag|
    tag.expand unless !tag.locals.presentation_pages.empty?
  end

  desc %{
    Renders the contained elements only if the current site_user has submitted any presentations
  }
  tag "ba:attendance:presentations:if" do |tag|
    tag.expand if !tag.locals.presentation_pages.empty?
  end

  desc %{
    Cycles through each of the current site_user's presentation pages. Works just like r:children:each.
  }
  tag "ba:attendance:presentations:each" do |tag|
    result = []
    edit_presentation_page = happening_page.edit_presentation_page
    tag.locals.presentation_pages.each do |presentation_page|
      edit_presentation_page.presentation_page = presentation_page
      tag.locals.page = edit_presentation_page
      tag.locals.child = edit_presentation_page
      result << tag.expand
    end
    result
  end
  
  tag "ba:presentation_page" do |tag|
    if @presentation
      tag.locals.page = @presentation
      tag.expand
    end
  end
  
  tag "ba:edit_presentation_link" do |tag|
    path = controller.__send__(:edit_presentation_path, tag.locals.page)
    %{<a href="#{path}">#{tag.locals.page.title}</a>}
  end

  desc "Displays event details as hCal" 
  tag "ba:hcal" do |tag|
    description = tag.attr['description']
    location = tag.attr['location']
    hp = happening_page

    %{<div class="vevent">
  <h3 class="summary"><a href="#{url}" class="url">#{title}</a></h3>
  <p class="description">#{description}</p>
  <p>
    <abbr class="dtstart" title="#{hp.starts_at.iso8601}">#{hp.starts_at.to_s(:long)}</abbr>
  </p>
  <p><span class="location">#{location}</span></p>
</div>}
  end
  
  desc %{
    Displays the name of the logged in site_user
  }
  tag "ba:site_user_name" do |tag|
    tag.locals.site_user.name
  end

  desc %{
    Tags inside this tag refer to the program of the happening.

    *Usage:*
    <pre><code>
    <r:ba:program empty_text="To be announced">
    <table>
      <tr>
        <td>13:00-13:45</td>
        <td><r:presentation slot="1000" empty_text="Keynote. Speaker to be announced later."/></td>
      </tr>
      <tr>
        <td>14:00-14:45</td>
        <td><r:presentation slot="1001" /></td>
      </tr>
      <tr>
        <td>15:00-15:45</td>
        <td><r:presentation slot="1002" /></td>
      </tr>
    </table>
    </r:ba:program>
    </code></pre>
    
    The empty_text value will be displayed when there is no assigned happening.
    This can be overridden in presentation tags underneath.
  }
  tag "ba:program" do |tag|
    tag.locals.empty_text = tag.attr["empty_text"] || "TBA"
    adm = self.respond_to?(:admin) && self.admin
    tag.locals.presentation_snippet = adm ? Snippet.find_by_name('presentation_admin') : Snippet.find_by_name('presentation')
    tag.expand
  end

  desc %{
    Renders an empty slot in the program, or the presentation title if one has been assigned
    in the program admin UI. (Coming soon: Rendering of links instead of just the title)
    
    The slot value must be unique across all the program pages within a happening.
    The empty_text value will be displayed when there is no assigned happening, and
    overrides any default value you may have set in the parent tag.
  }
  tag "ba:program:presentation" do |tag|
    program_slot = tag.attr["slot"]
    presentation_page = presentations_page.presentation_pages.at_slot(program_slot)
    if presentation_page
      presentation_page.request = request
      %{<div class="program slot" id="slot_#{program_slot}"><div class="presentation" id="presentation_#{presentation_page.id}">} +
      presentation_page.render_snippet(tag.locals.presentation_snippet) +
      %{</div></div>}
    else
      content = tag.attr["empty_text"] || tag.locals.empty_text
      "<div class=\"program slot\" id=\"slot_#{program_slot}\"><div class=\"empty\">#{content}</div></div>"
    end
  end

  tag "ba:presentations" do |tag|
    tag.expand
  end

  desc %{Loops over all the draft presentations for a happening}
  tag "ba:presentations:each_draft" do |tag|
    result = []
    happening_page.presentation_pages.drafts.each do |presentation_page|
      tag.locals.page = presentation_page
      tag.locals.child = presentation_page
      result << tag.expand
    end
    result
  end

  desc %{The id of a page}
  tag "ba:presentations:each_draft:id" do |tag|
    tag.locals.page.id
  end

  tag "ba:presentation" do |tag|
    tag.expand
  end

  tag "ba:presenter" do |tag|
    tag.locals.site_user = tag.locals.page.attendances.site_users[0]
    tag.expand
  end
  
  [:name, :company, :email].each do |field|
    tag "ba:presenter:#{field}" do |tag|
      tag.locals.site_user.__send__(field)
    end
  end

  [:name, :email, :activation_code].each do |field|
    desc %{The #{field} of the recipient. 
    
    This tag can only be used in the body section of email parts} 
    tag "ba:email:site_user:#{field}" do |tag|
      globals.site_user.__send__(field)
    end
  end

  desc %{Returns a parameter from the request. Useful for redesplaying values in failed
    form submissions like login. If used with a value, the content inside will be rendered
    if the value matches. Useful for checkboxes.

    *Usage:*
    <pre><code>
    <r:ba:request_param name="email" />
    </code></pre>
    
    Or inside an input field of type checkbox...
    
    <pre><code>
    <r:ba:request_param name="remember_me" value="1">checked="checked" </r:ba:request_param>
    </code></pre>
  }
  tag "ba:request_param" do |tag|
    name = tag.attr['name']
    req_value = request.parameters[name]
    tag_value = tag.attr['value']
    if tag_value && tag_value == req_value
      tag.expand
    else
      req_value
    end
  end

  tag "ba:if_flash" do |tag|
    key = tag.attr['key'].to_sym
    if controller.flash[key]
      tag.expand
    end
  end
end