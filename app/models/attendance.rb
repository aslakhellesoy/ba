class Attendance < ActiveRecord::Base
  belongs_to :happening_page
  belongs_to :site_user
  belongs_to :price

  has_many :presenters
  has_many :presentation_pages, :through => :presenters

  validates_presence_of :happening_page_id
  validates_uniqueness_of :site_user_id, :scope => :happening_page_id, :message => "already signed up"
  
  validate :site_user_valid
  validate :price_code_valid
  validate :new_presentation_valid

  after_save :create_new_presentation
  after_create :activate_user, :send_signup_confirmation_email
  
  attr_accessor :price_code

  def actual_price
    price || happening_page.default_price
  end
  
  def price_code_valid
    unless price_code.blank?
      self.price = happening_page.prices.find_by_code(price_code)
      errors.add(:price_code, "No such price code") if self.price.nil?
    end
  end
  
  def site_user_valid
    if site_user
      if !site_user.valid?
        errors.add_to_base("SiteUser is invalid")
      end
    end
  end
  
  def activate_user
    site_user.register! if site_user.passive?
    site_user.activate! if site_user.pending?
  end

  def new_presentation=(presentation_page)
    presentation_page.parent_id = happening_page.id
    @new_presentation_page = presentation_page
  end
  
  def new_presentation
    @new_presentation_page
  end
  
  def new_presentation_valid
    errors.add_to_base("Presentation is invalid") if new_presentation && !new_presentation.valid?
  end
  
  def create_new_presentation
    if new_presentation
      new_presentation.save!
      Presenter.create!(:presentation_page => new_presentation, :attendance => self)
    end
  end
  
  def send_signup_confirmation_email
    happening_page.send_signup_confirmation_email(site_user)
  end
  
end