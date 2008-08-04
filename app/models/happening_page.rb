class HappeningPage < Page
  has_many :prices do
    def default
      find_by_code ''
    end
  end
  has_many :attendances

  validates_presence_of :starts_at
  attr_accessor :controller, :page_type
    
  def presentations_page
    children.find_by_class_name('PresentationsPage')
  end

  def find_by_url(url, live = true, clean = false)
    if url =~ %r{^#{ self.url }(attendance)/$}
      @page_type = $1
      self
    else
      super
    end
  end

  def tag_part_name(tag)
    @page_type.nil? ? super : (tag.attr['part'] || @page_type.to_s)
  end

  def happening_page
    self
  end
  
  def new_attendance(attrs)
    attendances.build(attrs)
  end

  def attendance(site_user)
    site_user.nil? ? nil : attendances.find_by_site_user_id(site_user.id)
  end
  
  def default_price
    prices.default
  end
  
  def expire_programs
    children.find_all_by_class_name('ProgramPage').each do |program_page|
      ResponseCache.instance.expire_response(program_page.url)
    end
  end
  
  def attendance_url(site_user=nil)
    activation_code = site_user ? "?activation_code=#{site_user.activation_code}" : nil
    "#{url}attendance#{activation_code}"
  end
  
  def send_signup_confirmation_email(site_user)
    email_part = part('signup_confirmation_email')
    SiteUserMailer.deliver_part(email_part, site_user) unless email_part.nil?
  end
end

class Page < ActiveRecord::Base
  before_create :create_default_subpages
  before_create :create_default_happening_parts

  def create_default_subpages
    if class_name == 'HappeningPage'
      children << PresentationsPage.new
    end
  end

  def create_default_happening_parts
    if class_name == 'HappeningPage'
      parts << PagePart.new(:name => 'attendance', :content => %{
<r:ba:attendance:unless>
  <h3>Please sign up below</h3>
</r:ba:attendance:unless>
<r:ba:attendance:if>
  <h3>You are registered, <r:ba:site_user_name /></h3>
  You can change your details below.
</r:ba:attendance:if>

<r:ba:signup_form>
  <fieldset>
    <legend>Personal</legend>

    <p><label for="site_user_name">Name</label>
    <r:ba:input object="site_user" field="name" type="text"/></p>

    <p><label for="site_user_email">Email</label>
    <r:ba:input object="site_user" field="email" type="text"/></p>

    <p><label for="site_user_password">Choose Password</label>
    <r:ba:input object="site_user" field="password" type="password"/></p>

    <p><label for="site_user_password_confirmation">Confirm password</label>
    <r:ba:input object="site_user" field="password_confirmation" type="password"/></p>
  </fieldset>

  <fieldset>
    <legend>Attendance</legend>

    <p><label for="attendance_price_code">Price Code</label>
    <r:ba:input object="attendance" field="price_code" id="attendance_price_code" type="text"/></p>
  </fieldset>

  <p><input id="presenting" name="presenting" type="checkbox" value="1" />
  <label for="presenting">Add a presentation proposal</label></p>
  <script type="text/javascript">
    //<![CDATA[
    new Form.Element.EventObserver('presenting', function(element, value) {$("presentation_fields").toggle();})
    //]]>
  </script>

  <div id="presentation_fields" style="display: none">
    <fieldset>
      <legend>Presentation information</legend>

      <p><label for="presentation_title">Title</label><br/>
      <r:ba:input object="presentation" field="title" id="presentation_title" type="text"/></p>

      <p><label for="presentation_body">Description</label><br/>
      <r:ba:textarea object="presentation" field="body" cols="40" rows="20"/></p>
    </fieldset>
  </div>

  <input id="attendance_submit" name="commit" type="submit" value="Sign up" />

</r:ba:signup_form>

<r:ba:attendance:presentations:if>
Since you have submitted a proposal, you will only receive an invoice if none of your proposals are accepted.

Your proposals:
  <ul>
  <r:ba:attendance:presentations:each>
    <li><r:link /></li>
  </r:ba:attendance:presentations:each>
  </ul>
</r:ba:attendance:presentations:if>

<r:ba:attendance:presentations:unless>
We will send you an invoice of <r:ba:attendance:price /> later.
</r:ba:attendance:presentations:unless>
})
      parts << PagePart.new(:name => 'signup_confirmation_email', :content => %{From: "Conference Organizer" <conference@somewhere.com>
Subject: Thanks for signing up!

Hi, <r:ba:email:site_user:name />

This will be an awesome event!
})
    end
  end
end
