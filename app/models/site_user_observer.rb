class SiteUserObserver < ActiveRecord::Observer
  def after_create(site_user)
    SiteUserMailer.deliver_signup_notification(site_user)
  end

  def after_save(site_user)
  
    SiteUserMailer.deliver_activation(site_user) if site_user.recently_activated?
  
  end
end
