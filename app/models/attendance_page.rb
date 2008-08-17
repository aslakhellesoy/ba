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
        if create_presentation(request.parameters)
          controller.redirect_to(self.url)
        else
          super
        end
      else
        super
      end
    else
      # Nothing allowed here unless we're signed up
      controller.redirect_to(happening_page.signup_page.url)
    end
  end
  
  def create_presentation(params)
    @attendance.new_presentation = PresentationPage.new(params[:presentation])
    @presentation = @attendance.new_presentation
    @attendance.create_new_presentation
  end
end