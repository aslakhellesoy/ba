# This controller manages attendances, both showing forms and creating
# and modifying attendances. For the GET requests (#new, #edit and #show)
# there must be parts on the HappeningPage named "attendances/new",
# "attendances/show" and "attendances/edit", respectively.
#
class AttendancesController < SessionCookieController
  before_filter :find_page
  before_filter :authenticate_from_form, :only => :create
  before_filter :find_attendance, :only => [:show, :update]

  def show
    @site_user ||= current_site_user
    @happening_page.process(request, response)
    @performed_render = true
  end

  def create
    if @attendance
      # The user was logged out when form was submitted, and we found a user with an
      # attendance for the supplied login/password
      @attendance.attributes = params[:attendance]
    else
      @attendance = @happening_page.new_attendance(params[:attendance])
    end

    @attendance.site_user ||= (current_site_user || SiteUser.new)
    @attendance.site_user.attributes = (params[:site_user] || {})

    add_presentation
    
    if @attendance.save
      self.current_site_user = @attendance.site_user
      redirect_to attendance_path(:url => params[:url])
    else
      @happening_page.page_type = 'attendance'
      @site_user = @attendance.site_user # Just so the form can be populated again with what was typed
      show
    end
  end
  
  def update
    @attendance.attributes = params[:attendance]
    add_presentation

    if @attendance.save
      redirect_to attendance_path(:url => params[:url])
    else
      show
    end
  end

private
  
  def find_page
    found = Page.find_by_url(request.path, true)
    if found && found.published?
      @happening_page = found
      @happening_page.controller = self if @happening_page.respond_to?(:controller=)
    else
      render :template => 'site/not_found', :status => 404
    end
  end
  
  def authenticate_from_form
    return if self.current_site_user
    if params[:site_user] && (login = params[:site_user][:login]) && (password = params[:site_user][:password])
      self.current_site_user = SiteUser.authenticate(login, password)
      find_attendance
    end
  end
  
  def find_attendance
    @attendance = @happening_page.attendance(current_site_user)
  end

  def add_presentation
    @attendance.new_presentation = PresentationPage.new(params[:presentation]) if params[:presenting]
    @presentation = @attendance.new_presentation
  end
end