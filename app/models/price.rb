class Price < ActiveRecord::Base
  validates_uniqueness_of :code, :scope => :happening_page_id
  belongs_to :happening_page
  validates_presence_of :happening_page_id
end