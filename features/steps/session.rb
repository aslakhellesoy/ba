Given /I am logged in as "(\w+)"/ do |name|
  visits '/login'
  fills_in 'Email', :with => "#{name.downcase}@test.com"
  fills_in 'Password', :with => 'password'
  clicks_button 'Log in'
end

Given "I am logged out" do
  visits '/logout' rescue nil # Radiant barfs on logging out when you're not logged in
end

