class Price < ActiveRecord::Base
  belongs_to :happening_page
  validates_presence_of :happening_page_id
end