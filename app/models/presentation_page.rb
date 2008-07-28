class PresentationPage < Page
  before_create :assign_page_defaults
  
  def body=(body)
    parts << PagePart.new(:name => 'body', :content => body, :filter_id => 'Textile')
  end
  
  def title=(title)
    unless title.blank?
      self.breadcrumb = title
      self.slug = title.symbolize.to_s.gsub("_", "-")
    end
    super
  end
  
private

  def assign_page_defaults
  end
end