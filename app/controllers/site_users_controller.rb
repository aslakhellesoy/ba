class SiteUsersController < SessionCookieController
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_site_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  skip_before_filter :authenticate_from_activation_code

  # render new.rhtml
  def new
    @site_user = SiteUser.new
  end
 
  def create
    logout_keeping_session!
    @site_user = SiteUser.new(params[:site_user])
    @site_user.register! if @site_user && @site_user.valid?

    success = @site_user && @site_user.valid?
    if success && @site_user.errors.empty?
            redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    site_user = SiteUser.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && site_user && !site_user.active?
      site_user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to "/login"
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a site_user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def suspend
    @site_user.suspend! 
    redirect_to site_users_path
  end

  def unsuspend
    @site_user.unsuspend! 
    redirect_to site_users_path
  end

  def destroy
    @site_user.delete!
    redirect_to site_users_path
  end

  def purge
    @site_user.destroy
    redirect_to site_users_path
  end
  
  # There's no page here to update or destroy a site_user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_site_user
    @site_user = SiteUser.find(params[:id])
  end
end
