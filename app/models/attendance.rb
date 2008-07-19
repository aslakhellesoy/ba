class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :happening_page
end