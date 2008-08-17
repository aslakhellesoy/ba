Given /an? "(\w+)" site_user named "(\w+)" exists/ do |state, name|
  site_user = SiteUser.create!(
    :name => name, 
    :email => "#{name.downcase}@test.com", 
    :password => 'password', 
    :password_confirmation => 'password',
    :billing_address => "#{name} street",
    :billing_area_code => "9876",
    :billing_city => "Oslo"
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
  LoginPage.create # just in case
  visits '/login'
  fills_in 'Email', :with => "#{name.downcase}@test.com"
  fills_in 'Password', :with => 'password'
  clicks_button 'Log in'
end

Given "I am logged out" do
  visits '/logout' rescue nil # Radiant barfs on logging out when you're not logged in
end

Then /the site_user named "(\w+)" should be "(\w+)"/ do |name, state|
  SiteUser.find_by_name(name).state.should == state
end

