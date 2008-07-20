class HappeningPage < Page
  has_many :prices do
    def default
      find_by_code ''
    end
  end
  has_many :attendances

  validates_presence_of :starts_at
  attr_accessor :controller, :page_type
  
  def find_by_url(url, live = true, clean = false)
    if url =~ %r{^#{ self.url }(.+)/$}
      @page_type = $1
      @page_type = 'attendances/show' if @page_type =~ %r{attendances/\d+$}
      @page_type = 'attendances/already' if @page_type =~ %r{attendances/\d+/already$}
      self
    else
      super
    end
  end

  def tag_part_name(tag)
    @page_type.nil? ? super : (tag.attr['part'] || @page_type.to_s)
  end

  def cache?
    false
  end

  def happening_page
    self
  end
  
  def new_attendance(attrs)
    attendances.build(attrs)
  end

  def attendance(user)
    Attendance.find_by_happening_page_id_and_user_id(self.id, user.id)
  end
  
  def default_price
    prices.default
  end
end
