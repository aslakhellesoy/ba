# This controller manages attendances, both showing forms and creating
# and modifying attendances. For the GET requests (#new, #edit and #show)
# there must be parts on the HappeningPage named "attendances/new",
# "attendances/show" and "attendances/edit", respectively.
#
class AttendancesController < SiteController
  session :disabled => false

  before_filter :authenticate_user
  before_filter :find_page
  before_filter :redirect_if_signed_up, :only => [:new, :create]

  def new
    @happening_page.process(request, response)
    @performed_render = true
  end

  def show
    @happening_page.process(request, response)
    @performed_render = true
  end

  def already
    @happening_page.process(request, response)
    @performed_render = true
  end

  def create
    @attendance = @happening_page.new_attendance(params[:attendance])
    
    if !current_user
      self.current_user = User.create!(params[:user])
    end
    
    if @attendance.save
      redirect_to attendance_path(:url => params[:url], :id => @attendance.id)
    else
      render :action => "new"
    end
  end

private
  
  def authenticate_user
    if params[:user] && (login = params[:user][:login]) && (password = params[:user][:password])
      self.current_user = User.authenticate(login, password)
    end
  end
  
  def find_page
    found = Page.find_by_url(request.path, true)
    if found && found.published?
      @happening_page = found
      @happening_page.controller = self
    else
      render :template => 'site/not_found', :status => 404
    end
  end
    
  def redirect_if_signed_up
    if current_user && attendance = @happening_page.attendance(current_user)
      redirect_to already_attendance_path(:url => params[:url], :id => attendance.id)
    end
  end
end