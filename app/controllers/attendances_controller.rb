# This controller manages attendances, both showing forms and creating
# and modifying attendances. For the GET requests (#new, #edit and #show)
# there must be parts on the HappeningPage named "attendances/new",
# "attendances/show" and "attendances/edit", respectively.
#
class AttendancesController < SessionCookieController
  before_filter :authenticate_site_user
  before_filter :find_page
  before_filter :find_attendance, :only => [:show, :update, :create]
  before_filter :redirect_if_attendance, :only => [:create]

  def show
    @happening_page.process(request, response)
    @performed_render = true
  end

  def create
    @attendance = @happening_page.new_attendance(params[:attendance])
    # add_site_user
    if current_site_user
      @attendance.site_user = current_site_user
    else
      @attendance.site_user = SiteUser.new(params[:site_user])
    end
    @site_user = @attendance.site_user # Just so the form can be populated

    # add_presentation
    @attendance.new_presentation = Presentation.new(params[:presentation]) if params[:presenting]
    @presentation = @attendance.new_presentation
    
    if @attendance.save
      self.current_site_user = @attendance.site_user
      redirect_to attendance_path(:url => params[:url])
    else
      @happening_page.page_type = 'attendance'
      show
    end
  end
  
  def update
    if @attendance.update_attributes(params[:attendance])
      redirect_to attendance_path(:url => params[:url])
    else
      show
    end
  end

private
  
  def authenticate_site_user
    if params[:site_user] && (login = params[:site_user][:login]) && (password = params[:site_user][:password])
      self.current_site_user = SiteUser.authenticate(login, password)
    end
  end
  
  def find_page
    found = Page.find_by_url(request.path, true)
    if found && found.published?
      @happening_page = found
      @happening_page.controller = self if @happening_page.respond_to?(:controller=)
    else
      render :template => 'site/not_found', :status => 404
    end
  end
  
  def find_attendance
    @attendance = @happening_page.attendance(current_site_user)
  end

  def redirect_if_attendance
    redirect_to attendance_path(:url => params[:url]) if @attendance
  end
end