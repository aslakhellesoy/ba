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
      email = request.parameters[:email]
      site_user = SiteUser.find_by_email(email)
      site_user.make_reset_code!
      send_reset_password_email(site_user)
      controller.flash[:reset_password_email_sent] = true
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
    parts << PagePart.new(:name => 'reset_password_email', :content => read_file('default_reset_password_email_part.txt'))
  end
  
  def send_reset_password_email(site_user)
    email_part = part('reset_password_email')
    SiteUserMailer.deliver_part(email_part, site_user) unless email_part.nil?
  end
  
end