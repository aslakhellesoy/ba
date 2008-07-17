module BaTags
  include Radiant::Taggable

  desc "Displays event details as hCal" 
  tag "hcal" do |tag|
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
    If the current user is not signed up, renders a signup form.
    Otherwise, renders a link that points to attendance details.
    This tag can only be used on attendances/* parts of a Happening page.
  }
  tag "signup" do |tag|
    render_partial('attendances/new')
  end
  
  def attendance_link(attendance)
    "You are signed up. <a href=\"#{happening_page.url}attendance/#{attendance.user_id}/\">View details</a>."
  end
  
  def render_partial(partial)
    page = self
    url = page.url.split('/').reject{|e| e.blank?}
    controller.instance_eval do
      render :locals => {:page => page, :url => url}, :partial => partial
    end
  end
end