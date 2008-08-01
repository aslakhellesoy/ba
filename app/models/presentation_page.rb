class PresentationPage < Page
  validates_presence_of :parent_id
  validates_uniqueness_of :program_slot, :scope => 'parent_id', :allow_blank => true
  
  before_validation_on_update :remove_slot_from_other
  before_update :set_state_based_on_slot
  after_update :expire_programs
  
  def body=(body)
    parts << PagePart.new(:name => 'body', :content => body, :filter_id => 'Textile')
  end
  
  def body
    body_part = part('body')
    body_part ? body_part.content : ""
  end
  
  def title=(title)
    unless title.blank?
      self.breadcrumb = title
      self.slug = title.symbolize.to_s.gsub("_", "-")
    end
    super
  end

private

  def remove_slot_from_other
    unless program_slot.blank?
      other = parent.presentation_pages.with_slot(program_slot)
      if other
        other.program_slot = nil
        other.save!
      end
    end
  end
  
  def set_state_based_on_slot
    if program_slot.blank?
      self.status = Status[:draft]
    else
      self.status = Status[:published]
    end
  end
  
  def expire_programs
    happening_page.expire_programs
  end
end