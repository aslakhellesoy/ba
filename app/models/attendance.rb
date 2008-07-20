class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :happening_page
  belongs_to :price
  validates_presence_of :happening_page_id
  
  validate :user_valid
  
  def actual_price
    price || happening_page.prices.first
  end
  
  def user_valid
    errors.add_to_base("User is invalid") if user && !user.valid?
  end
end