class Attendance < ActiveRecord::Base
  belongs_to :happening_page
  belongs_to :user
  belongs_to :price

  validates_presence_of :happening_page_id
  validate :user_valid
  validate :price_code_valid
  
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
  
  def user_valid
    errors.add_to_base("User is invalid") if user && !user.valid?
  end
end