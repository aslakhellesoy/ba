Given /a user named "(\w+)" exists/ do |name|
  User.create!(
    :name => name, 
    :email => "#{name.downcase}@test.com", 
    :login => name.downcase, 
    :password => 'password', 
    :password_confirmation => 'password'
  )
end

Given /I am logged in as "(\w+)"/ do |name|
  visits '/admin/login'
  fills_in 'Username', :with => name.downcase
  fills_in 'Password', :with => 'password'
  clicks_button 'Login'
end

Given "I am logged out" do
  visits '/admin/logout' rescue nil # Radiant barfs on logging out when you're not logged in
end