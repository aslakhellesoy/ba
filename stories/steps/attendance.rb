When /I fill in personal info for "(\w+)"/ do |name|
  fills_in 'Name', :with => name
  # fills_in 'Company', :with => 'My Company'
  fills_in 'Email', :with => "#{name.downcase}@test.com"
  fills_in 'Login', :with => name.downcase
  fills_in 'Password', :with => "password"
  fills_in 'Confirm Password', :with => "password"
end
