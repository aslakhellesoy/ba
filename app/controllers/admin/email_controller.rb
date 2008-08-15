class Admin::EmailController < ApplicationController
  def new
    if request.post?
      create
    else
      include_javascript 'admin/table_filter.js'
      @site_users = SiteUser.find(:all)
    end
  end
  
  def create
    n = SiteUserMailer.mass_mail(params[:email])
    flash[:notice] = "Sent emails to #{n} site users"
    redirect_to email_new_url
  end
end