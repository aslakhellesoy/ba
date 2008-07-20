class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :happening_page
  belongs_to :price

  validate :user_valid
  validates_presence_of :happening_page_id
  before_create :find_price
  
  attr_accessor :price_code

  def actual_price
    price || happening_page.default_price
  end
  
  def find_price
    self.price = happening_page.prices.find_by_code(price_code)
  end
  
  def user_valid
    errors.add_to_base("User is invalid") if user && !user.valid?
  end
end