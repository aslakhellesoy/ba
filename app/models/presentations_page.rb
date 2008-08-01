# Nothing fancy about this page type, except that all HappeningPage records
# will have one, and it will be the parent of all PresentationPage records.
# It's just to avoid too many pages right underneath a happening page.
#
class PresentationsPage < Page
  validates_presence_of :parent_id
  after_create :kidnap_children
  
  has_many :presentation_pages, :foreign_key => 'parent_id' do
    def drafts
      find_all_by_status_id(Status[:draft].id)
    end
    
    def with_slot(program_slot)
      find_by_program_slot(program_slot)
    end
  end
  
  def initialize(*a)
    super
    self.slug = self.title = self.breadcrumb = 'presentations'
    self.status = Status[:hidden]
  end
  
  def kidnap_children #:nodoc: only used in migration 007
    parent.children.find_all_by_class_name('PresentationPage').each do |p|
      p.update_attribute(:parent_id, self.id)
    end
  end
end