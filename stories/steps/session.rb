Given /an? "(\w+)" site_user named "(\w+)" exists/ do |state, name|
  site_user = SiteUser.create!(
    :name => name, 
    :email => "#{name.downcase}@test.com", 
    :password => 'password', 
    :password_confirmation => 'password'
  )
  site_user.register!
  if state == "pending" # Use must set password when they log in via activation link
    site_user.password = nil
    site_user.crypted_password = nil
    site_user.save_without_validation
  end
  site_user.activate! if state == "active"
end

Given /I am logged in as "(\w+)"/ do |name|
  visits '/login'
  fills_in 'Email', :with => "#{name.downcase}@test.com"
  fills_in 'Password', :with => 'password'
  clicks_button 'Log in'
end

Given "I am logged out" do
  visits '/logout' rescue nil # Radiant barfs on logging out when you're not logged in
end