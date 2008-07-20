module BaTags
  include Radiant::Taggable

  tag "ba" do |tag|
    tag.locals.user = controller.__send__(:current_user) if self.respond_to?(:controller) && controller.respond_to?(:current_user)
    tag.expand
  end

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