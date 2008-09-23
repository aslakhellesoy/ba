class Attendance < ActiveRecord::Base
  belongs_to :happening_page
  belongs_to :site_user
  belongs_to :price

  has_many :presenters, :dependent => :destroy
  has_many :presentation_pages, :through => :presenters, :dependent => :destroy

  validates_presence_of :happening_page_id
  validates_uniqueness_of :site_user_id, :scope => :happening_page_id, :message => "already signed up"
  
  validate :site_user_valid
  validate :price_code_valid

  before_save :update_price
  after_create :activate_user, :send_signup_confirmation_email

  def price_code=(pc)
    @price_code = pc
  end

  def price_code
    @price_code || price.code
  end

  def actual_price
    price || happening_page.default_price
  end
  
  def price_code_valid
    @old_price = self.price
    self.price = happening_page.prices.find_by_code(@price_code || "")
    errors.add(:price_code, "No such price code") if self.price.nil?
    if self.price && !self.price.available?
      price_users = price.attendances.map(&:site_user).map{|u| %{<a href="mailto:#{u.email}">#{u.name}</a>}}.join(", ")
      errors.add(:price_code, "no longer available, used by #{price_users}")
    end
  end
  
  def site_user_valid
    if site_user
      if !site_user.valid?
        errors.add_to_base("SiteUser is invalid")
      end
    end
  end
  
  def update_price
    if @old_price != price
      self.amount = price.amount
      self.currency = price.currency
    end
  end
  
  def activate_user
    site_user.register! if site_user.passive?
    site_user.activate! if site_user.pending?
  end

  def save_presentation(presentation_page)
    presentation_page.parent_id = happening_page.presentations_page.id
    needs_presenter = presentation_page.new_record?
    if presentation_page.save && needs_presenter
      Presenter.create!(:presentation_page => presentation_page, :attendance => self)
    end
    !presentation_page.new_record?
  end
  
  def send_signup_confirmation_email
    happening_page.send_signup_confirmation_email(site_user)
  end
  
end