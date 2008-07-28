class PresentationPage < Page
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
end