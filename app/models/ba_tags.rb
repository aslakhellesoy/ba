module BaTags
  include Radiant::Taggable

  tag "ba" do |tag|
    tag.locals.user = controller.__send__(:current_user) if self.respond_to?(:controller) && controller.respond_to?(:current_user)
    tag.expand
  end

  desc %{
    Tags inside this tag refer to the attendance of the current user.
  }
  tag "ba:attendance" do |tag|
    tag.locals.attendance = happening_page.attendance(tag.locals.user)
    tag.expand
  end

  desc %{
    Renders the price (currency and amount) of the signed in user's attendance
    to the happening.
    
    *Usage:* 
    <pre><code><r:ba:attendance:price [free="free_text"]/></code></pre>
  }
  tag "ba:attendance:price" do |tag|
    price = tag.locals.attendance.actual_price
    free = tag.attr['free'] || 'free'
    price ? "#{price.currency} #{price.amount}" : free
  end

  desc %{
    Renders the contained elements only if the current user has NOT submitted any presentations
  }
  tag "ba:attendance:unless_presentations" do |tag|
    tag.expand unless tag.locals.attendance.presentations.count > 0
  end

  desc %{
    Renders the contained elements only if the current user has submitted any presentations
  }
  tag "ba:attendance:if_presentations" do |tag|
    tag.expand if tag.locals.attendance.presentations.count > 0
  end

  desc %{
    Tags inside this tag refer to the presentations of the current user.
  }
  tag "ba:attendance:presentations" do |tag|
    tag.locals.presentations = tag.locals.attendance.presentations
    tag.expand
  end

  desc %{
    Cycles through each of the current user's presentations. Inside this tag all page attribute tags
    are mapped to the current presentation.
  }
  tag "ba:attendance:presentations:each" do |tag|
    result = []
    tag.locals.presentations.each do |presentation|
      tag.locals.presentation = presentation
      result << tag.expand
    end
    result
  end

  desc %{
    Renders the title of the current presentation.
  }
  tag "ba:attendance:presentations:each:title" do |tag|
    tag.locals.presentation.title
  end

  desc "Displays event details as hCal" 
  tag "ba:hcal" do |tag|
    description = tag.attr['description']
    location = tag.attr['location']

    %{<div class="vevent">
  <h3 class="summary"><a href="#{url}" class="url">#{title}</a></h3>
  <p class="description">#{description}</p>
  <p>
    <abbr class="dtstart" title="#{starts_at.iso8601}">#{starts_at.to_s(:long)}</abbr>
  </p>
  <p><span class="location">#{location}</span></p>
</div>}
  end

  desc %{
    Renders a signup form for the happening.
    This tag can only be used on attendances/* parts of a Happening page.
    
    NOTE: You MUST make sure the layout used for your page includes the prototype.js
    javascript in the head section:
    
    <pre><code><script src="/javascripts/prototype.js" type="text/javascript"></script></code></pre>
  }
  tag "ba:signup" do |tag|
    render_partial('attendances/new')
  end
  
  def render_partial(partial)
    page = self
    url = page.url.split('/').reject{|e| e.blank?}
    controller.instance_eval do
      render :locals => {:page => page, :url => url}, :partial => partial
    end
  end
  
  desc %{
    Displays the name of the logged in user
  }
  tag "ba:user_name" do |tag|
    tag.locals.user.name
  end
end