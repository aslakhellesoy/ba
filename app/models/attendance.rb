class Attendance < ActiveRecord::Base
  belongs_to :happening_page
  belongs_to :user
  belongs_to :price

  has_many :presenters
  has_many :presentations, :through => :presenters

  validates_presence_of :happening_page_id
  validate :user_valid
  validate :price_code_valid
  validate :presentation_valid

  after_create :create_presentation
  
  attr_accessor :price_code, :presentation

  def actual_price
    price || happening_page.default_price
  end
  
  def price_code_valid
    unless price_code.blank?
      self.price = happening_page.prices.find_by_code(price_code)
      errors.add(:price_code, "No such price code") if self.price.nil?
    end
  end
  
  def user_valid
    errors.add_to_base("User is invalid") if user && !user.valid?
  end

  def presentation_valid
    errors.add_to_base("Presentation is invalid") if presentation && !presentation.valid?
  end
  
  def create_presentation
    if presentation
      presentation.save!
      Presenter.create!(:presentation => presentation, :attendance => self)
    end
  end
  
end