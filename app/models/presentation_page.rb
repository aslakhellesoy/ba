class PresentationPage < Page
  validates_uniqueness_of :program_slot, :scope => 'parent_id'
  
  after_update do |presentation_page|
    presentation_page.happening_page.expire_programs
  end
  
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