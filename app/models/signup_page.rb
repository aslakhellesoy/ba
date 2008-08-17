class SignupPage < Page
  before_validation_on_create :create_default_content

  def cache?
    false
  end

  def create_default_content
    self.slug = 'signup'
    self.breadcrumb = self.title = 'Sign up'
    self.status = Status[:published]
    parts << PagePart.new(:name => 'body', :content => read_file('default_signup_part.html'))
  end
  
  def process(request, response)
    @site_user = controller.current_site_user || SiteUser.new
    @attendance = happening_page.attendance(@site_user)

    if !@attendance
      if request.post?
        if create_attendance(request.parameters)
          controller.current_site_user = @attendance.site_user # Log in
          controller.redirect_to(happening_page.attendance_page.url)
        else
          super
        end
      else
        super
      end
    else
      controller.redirect_to(happening_page.attendance_page.url)
    end
  end
  
  def create_attendance(params)
    @attendance = happening_page.new_attendance(params[:attendance])
    @attendance.site_user = @site_user
    @attendance.site_user.attributes = (params[:site_user] || {})
    @attendance.save
  end
end