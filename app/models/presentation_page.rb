class PresentationPage < Page
  validates_presence_of :parent_id
  validates_presence_of :body
  validates_uniqueness_of :program_slot, :scope => 'parent_id', :allow_blank => true
  
  has_many :presenters, :dependent => :destroy
  has_many :attendances, :through => :presenters, :dependent => :destroy

  before_update :set_state_based_on_slot
  
  def body=(body)
    body_part = part('body')
    if body_part.nil?
      parts << PagePart.create!(:name => 'body', :filter_id => 'Textile', :content => body)
    else
      body_part.update_attribute(:content, body)
    end
  end
  
  def body
    body_part = part('body')
    body_part ? body_part.content : nil
  end
  
  def title=(title)
    unless title.blank?
      self.breadcrumb = title
      self.slug = title.symbolize.to_s.gsub("_", "-")
    end
    super
  end
  
  def editable_by?(site_user)
    site_user && attendances.map(&:site_user).index(site_user)
  end

  def clear_slot
    parent.presentation_pages.clear_slot(program_slot)
  end

  def expire_programs
    happening_page.expire_programs
  end

private

  def set_state_based_on_slot
    if program_slot.blank?
      self.status = Status[:draft]
    else
      self.status = Status[:published]
    end
  end
end