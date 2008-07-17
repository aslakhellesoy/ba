class HappeningPage < Page
  belongs_to :price
  has_many :attendances

  validates_presence_of :starts_at
  attr_accessor :controller
  
  def find_by_url(url, live = true, clean = false)
    if url =~ %r{^#{ self.url }(attendances\/[^/]+)/?$}
      @page_type = $1
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
  
end
