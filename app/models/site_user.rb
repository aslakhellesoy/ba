require 'digest/sha1'

class SiteUser < ActiveRecord::Base

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  validates_format_of       :name,     :with => RE_NAME_OK,  :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  validates_presence_of     :billing_address
  validates_length_of       :billing_address, :minimum => 5

  validates_presence_of     :billing_address
  validates_length_of       :billing_address, :minimum => 5
  validates_presence_of     :billing_area_code
  validates_length_of       :billing_area_code, :minimum => 3
  validates_presence_of     :billing_city
  validates_length_of       :billing_city, :minimum => 2

  has_many :attendances, :dependent => :destroy
  has_many :happening_pages, :through => :attendances, :dependent => :destroy

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a site_user from submitting a crafted form that bypasses activation
  # anything else you want your site_user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation, 
    :phone_number, :title, :role, :company, :billing_address, :billing_area_code,
    :billing_city

  def clear_reset_code!
    self.reset_code = nil
    save(false)
  end

  def recently_reset_password?
    @reset_code_set
  end

  def make_reset_code!
    @reset_code_set = true
    self.reset_code = self.class.make_token
    save(false)
  end

  # Authenticates a site_user by their email and unencrypted password.  Returns the site_user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    u = find_in_state :first, :active, :conditions => {:email => email} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  protected
    
    def make_activation_code
        self.deleted_at = nil
        self.activation_code = self.class.make_token
    end


end
