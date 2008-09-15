class ProgramPage < Page
  attr_accessor :admin # Set to true if showed in admin interface
  validates_presence_of :parent_id
end