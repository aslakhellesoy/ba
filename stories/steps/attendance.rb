Given /"(\w+)" is signed up for "(\w+)"/ do |site_user_name, title|
  site_user = SiteUser.find_by_name(site_user_name)
  page = Page.find_by_title(title)
  attendance = Attendance.create! :site_user => site_user, :happening_page => page
end

When /I view the "(\w+)" signup page/ do |title|
  page = Page.find_by_title(title)
  visits page.url + "attendances/new"
end

When /I fill in personal info for "(\w+)"/ do |name|
  fills_in 'Name', :with => name
  # fills_in 'Company', :with => 'My Company'
  fills_in 'Email', :with => "#{name.downcase}@test.com"
  fills_in 'Login', :with => name.downcase
  fills_in 'Password', :with => "password"
  fills_in 'Confirm Password', :with => "password"
end
