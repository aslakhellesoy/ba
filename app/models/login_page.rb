class LoginPage < Page
  description %{
    This page displays a login form for the site (for Site users). There
    should only be one of it, and it should be at /login
  }

  before_validation_on_create :create_default_content

  def cache?
    false
  end
  
  def create_default_content
    self.parent = Page.find_by_url('/')
    self.slug = 'login'
    self.breadcrumb = self.title = 'Log in'
    self.status = Status[:published]

    parts << PagePart.new(:name => 'body', :content => read_file('default_login_part.html'))
  end
end