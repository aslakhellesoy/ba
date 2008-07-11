class AttendanceController < ApplicationController
  skip_before_filter :verify_authenticity_token
  no_login_required
  
  def create
    page = Page.find_by_url(page_url)
    redirect_to page.happening_page.url
  end

private

  def page_url
    url = params[:url]
    if Array === url
      url = url.join('/')
    else
      url = url.to_s
    end
  end
end