class Presenter < ActiveRecord::Base
  belongs_to :presentation_page
  belongs_to :attendance
end