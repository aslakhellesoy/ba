Given /a site_user named "(\w+)" exists/ do |name|
  site_user = SiteUser.create!(
    :name => name, 
    :email => "#{name.downcase}@test.com", 
    :login => name.downcase, 
    :password => 'password', 
    :password_confirmation => 'password'
  )
  site_user.register!
  site_user.activate!
end

Given /I am logged in as "(\w+)"/ do |name|
  visits '/login'
  fills_in 'Login', :with => name.downcase
  fills_in 'Password', :with => 'password'
  clicks_button 'Log in'
end

Given "I am logged out" do
  visits '/admin/logout' rescue nil # Radiant barfs on logging out when you're not logged in
end