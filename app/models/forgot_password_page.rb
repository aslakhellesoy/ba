class ForgotPasswordPage < Page
  description %{
    This page displays a page where people can ask for a reset password link.
  }

  before_validation_on_create :create_default_content

  def cache?
    false
  end

  def process(request, response)
    if request.post?
      controller.redirect_to(self.url)
    else
      super
    end
  end
  
  def create_default_content
    self.parent = Page.find_by_url('/')
    self.slug = 'forgot'
    self.breadcrumb = self.title = 'Forgot Password'
    self.status = Status[:published]

    parts << PagePart.new(:name => 'body', :content => read_file('default_forgot_password_part.html'))
  end
end