class HappeningPage < Page
  has_many :prices do
    def default
      find_by_code ''
    end
  end
  has_many :attendances

  validates_presence_of :starts_at
  attr_accessor :controller, :page_type
    
  before_create :create_default_happening_parts
  before_create :create_default_subpages

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

  def create_default_subpages
    if class_name == 'HappeningPage'
      children << PresentationsPage.new
    end
  end

  def create_default_happening_parts
    if class_name == 'HappeningPage'
      parts << PagePart.new(:name => 'attendance', :content => %{
<r:ba:attendance:unless>
<h2>Please sign up below</h2>
<r:ba:new_attendance_form />
</r:ba:attendance:unless>

<r:ba:attendance:if>
<h2>You are registered, <r:ba:site_user_name /></h2>

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

You can change your attendance details here:
<r:ba:attendance:form />

</r:ba:attendance:if>
})
      parts << PagePart.new(:name => 'signup_confirmation_email', :content => %{From: "Conference Organizer" <conference@somewhere.com>
Subject: Thanks for signing up!

Hi, <r:ba:email:site_user:name />

This will be an awesome event!
})
    end
  end
end
