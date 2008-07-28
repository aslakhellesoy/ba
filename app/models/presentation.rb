class Presentation < ActiveRecord::Base
  order_by :title
  
  validates_presence_of :title
  validates_presence_of :description
end