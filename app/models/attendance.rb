class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :happening_page
  
  validate :user_valid
  
  def user_valid
    errors.add_to_base("User is invalid") if user && !user.valid?
  end
end