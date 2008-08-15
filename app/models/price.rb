class Price < ActiveRecord::Base
  belongs_to :happening_page
  has_many :attendances

  validates_uniqueness_of :code, :scope => :happening_page_id
  validates_presence_of :happening_page_id
  
  def visual_name
    code.blank? ? "[DEFAULT]" : code
  end
  
  def used
    attendances.count
  end
  
  def available?
    max.nil? || used < max
  end
end