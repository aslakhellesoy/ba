class PresentationsController < SessionCookieController
  before_filter :find_presentation
  
  def edit
    happening_page = @presentation.happening_page
    happening_page.page_type = 'edit_presentation'
    happening_page.controller = self
    happening_page.process(request, response)
    @performed_render = true
  end

  def update
    if @presentation.update_attributes(params[:presentation])
      happening_page = @presentation.happening_page
      redirect_to attendance_path(:url => happening_page.url_array)
    else
      edit
    end
  end
  
private

  def find_presentation
    @presentation = PresentationPage.find(params[:id])
    raise "Not allowed" unless @presentation.editable_by?(current_site_user)
  end
end