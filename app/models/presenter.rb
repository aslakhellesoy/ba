class Presenter < ActiveRecord::Base
  belongs_to :presentation
  belongs_to :attendance
end