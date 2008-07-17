# This controller manages attendances, both showing forms and creating
# and modifying attendances. For the GET requests (#new, #edit and #show)
# there must be parts on the HappeningPage named "attendances/new",
# "attendances/show" and "attendances/edit", respectively.
#
class AttendancesController < SiteController
  session :disabled => false

  def process_page_with_controller(page)
    page.controller = self
    process_page_without_controller(page)
  end
  alias_method_chain :process_page, :controller
  
  def new
    show_uncached_page(url + "/attendances/new")
  end

  def show
    show_uncached_page(url + "/attendances/show")
  end

  def create
    @happening_page = find_page(url)
    @attendance = @happening_page.new_attendance(params[:attendance])
    
    if @attendance.save
      redirect_to attendance_path(:url => params[:url], :id => @attendance.id)
    else
      render :action => "new"
    end
  end

private
  
  def url
    if Array === params[:url]
      params[:url].join('/')
    else
      params[:url].to_s
    end
  end
end