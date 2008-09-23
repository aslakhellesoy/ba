class AttendancePage < Page
  before_validation_on_create :create_default_content

  def cache?
    false
  end

  def create_default_content
    self.slug = 'attendance'
    self.breadcrumb = self.title = 'Attendance'
    self.status = Status[:published]
    parts << PagePart.new(:name => 'body', :content => read_file('default_attendance_part.html'))
  end

  def process(request, response)
    @site_user = controller.current_site_user
    @attendance = happening_page.attendance(@site_user)

    if @attendance
      if request.post?
        if update_attendance(request.parameters)
          controller.redirect_to(self.url)
        else
          super
        end
      else
        super
      end
    else
      # Nothing allowed here unless we're signed up
      if @site_user
        controller.redirect_to(happening_page.signup_page.url)
      else
        controller.session[:return_to] = url
        login_page = LoginPage.find(:first)
        controller.redirect_to(login_page.url)
      end
    end
  end
  
  def update_attendance(params)
    @attendance.update_attributes(params[:attendance])
  end
end