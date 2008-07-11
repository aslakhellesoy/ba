class HappeningPage < Page
  validates_presence_of :starts_at
  
  def happening_page
    self
  end
  
  def attendance
    nil
  end
end
