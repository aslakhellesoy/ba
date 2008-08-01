module AuthenticatedTestHelper
  # Sets the current site_user in the session from the site_user fixtures.
  def login_as(site_user)
    @request.session[:site_user_id] = site_user ? site_users(site_user).id : nil
  end

  def authorize_as(site_user)
    @request.env["HTTP_AUTHORIZATION"] = site_user ? ActionController::HttpAuthentication::Basic.encode_credentials(site_users(site_user).email, 'monkey') : nil
  end
  
  # rspec
  def mock_site_user
    site_user = mock_model(SiteUser, :id => 1,
      :email  => 'site_user_name@example.com',
      :name   => 'U. Surname',
      :to_xml => "SiteUser-in-XML", :to_json => "SiteUser-in-JSON", 
      :errors => [])
    site_user
  end  
end
