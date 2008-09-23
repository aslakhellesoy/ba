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

Then /the site_user named "(\w+)" should be "(\w+)"/ do |name, state|
  SiteUser.find_by_name(name).state.should == state
end

Then /"(.*)"'s Email should be "(.*)"/ do |name, email| #'
  SiteUser.find_by_name(name).email.should == email
end

When /I view the account page/ do
  visits "/account"
end

When /I view the forgot password page/ do
  visits "/forgot"
end
