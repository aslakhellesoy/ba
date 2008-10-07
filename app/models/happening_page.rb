class HappeningPage < Page
  has_many :prices, :dependent => :destroy do
    def default
      find_by_code ''
    end
  end
  has_many :attendances, :dependent => :destroy, :order => 'created_at asc'

  validates_presence_of :starts_at
  attr_accessor :page_type, :email_exists

  def happening_page
    self
  end
  
  def signup_page
    children.find_by_class_name('SignupPage')
  end

  def attendance_page
    children.find_by_class_name('AttendancePage')
  end

  def edit_presentation_page
    children.find_by_class_name('EditPresentationPage')
  end

  def presentations_page
    children.find_by_class_name('PresentationsPage')
  end

  def new_attendance(attrs)
    attendances.build(attrs)
  end

  def attendance(site_user)
    site_user.nil? ? nil : attendances.find_by_site_user_id(site_user.id)
  end
  
  def default_price
    @default_price ||= prices.default
  end
  
  def attendance_trend
    atts = attendances
    day = atts[0].created_at.midnight.utc
    last = atts[-1].created_at.tomorrow.midnight.utc
    result = []
    count = 0
    while(day < last)
      count += atts.find_all{|r| r.created_at.midnight == day}.length
      result << [day, count]
      day = day.tomorrow
    end
    result
  end
  
  def expire_programs
    children.find_all_by_class_name('ProgramPage').each do |program_page|
      ResponseCache.instance.expire_response(program_page.url)
    end
  end
  
  def send_signup_confirmation_email(site_user)
    email_part = part('signup_confirmation_email')
    SiteUserMailer.deliver_part_mail(email_part, site_user) unless email_part.nil?
  end
end

class Page < ActiveRecord::Base
  include BaTags
  
  before_create :create_default_subpages
  before_create :create_presentation_snippets
  before_create :create_default_happening_parts
  after_create  :create_default_price

  def create_default_subpages
    if class_name == 'HappeningPage'
      children << SignupPage.new
      children << AttendancePage.new
      children << EditPresentationPage.new
      children << PresentationsPage.new
    end
  end

  def create_default_happening_parts
    if class_name == 'HappeningPage'
      parts << PagePart.new(:name => 'signup_confirmation_email', :content => %{From: "Conference Organizer" <conference@somewhere.com>
Subject: Thanks for signing up!

Hi, <r:ba:email:site_user:name />

This will be an awesome event!
})
    end
  end
  
  def create_presentation_snippets
    unless Snippet.find_by_name('presentation')
      Snippet.create! :name => 'presentation', :content => %{<strong><r:link /></strong>
<div><r:ba:presenter:name /> (<r:ba:presenter:company />)</div>}
    end
    unless Snippet.find_by_name('presentation_admin')
      Snippet.create! :name => 'presentation_admin', :content => %{<strong><r:link /></strong>
<div><r:ba:presenter:name />, <r:ba:presenter:email />, <r:ba:presenter:company /></div>
<div><r:tags /></div>}
    end
  end
  
  def create_default_price
    if class_name == 'HappeningPage'
      happening_page = HappeningPage.find(id)
      happening_page.prices.create!(:code => '', :currency => 'NOK', :amount => 250)
    end
  end
  
  def happening_page
    if HappeningPage == parent
      parent
    elsif parent
      parent.happening_page
    else
      nil
    end
  end
  
  def presentations_page
    happening_page.presentations_page
  end

  def presentation_pages
    presentations_page.presentation_pages
  end

  def url_array
    url.split('/').reject{|e| e.blank?}
  end

  def read_file(name)
    IO.read(File.dirname(__FILE__) + "/#{name}")
  end
end
