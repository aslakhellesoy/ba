# This controller handles the login/logout function of the site.  
class SiteSessionsController < SessionCookieController

  def create
    logout_keeping_session!
    site_user = SiteUser.authenticate(params[:email], params[:password])
    if site_user
      # Protects against session fixation attacks, causes request forgery
      # protection if site_user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_site_user = site_user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      flash[:login_success] = true
      redirect_back_or_default('/')
    else
      note_failed_signin
      login_page = LoginPage.find(:first)
      login_page.controller = self
      login_page.process(request, response)
      @performed_render = true
    end
  end

  def destroy
    logout_killing_session!
    flash[:logout_success] = true
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:login_failure] = true
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
