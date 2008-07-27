class SiteUserMailer < ActionMailer::Base
  def signup_notification(site_user)
    setup_email(site_user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://YOURSITE/activate/#{site_user.activation_code}"
  
  end
  
  def activation(site_user)
    setup_email(site_user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://YOURSITE/"
  end
  
  protected
    def setup_email(site_user)
      @recipients  = "#{site_user.email}"
      @from        = "ADMINEMAIL"
      @subject     = "[YOURSITE] "
      @sent_on     = Time.now
      @body[:site_user] = site_user
    end
end
