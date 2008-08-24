# Baseclass for all Ba controllers that use a cookie-based session
class SessionCookieController < ActionController::Base
  include AuthenticatedSystem
  before_filter :authenticate_from_activation_code

  public :redirect_to, :flash

private
  
  def authenticate_from_activation_code
    if params[:activation_code]
      logout_keeping_session!
      site_user = SiteUser.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
      if (!params[:activation_code].blank?) && site_user && !site_user.active?
        self.current_site_user = site_user
      end
    end
  end
end