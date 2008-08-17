Given /"(\w+)" is signed up for "(\w+)"/ do |site_user_name, title|
  site_user = SiteUser.find_by_name(site_user_name)
  page = Page.find_by_title(title)
  attendance = Attendance.create! :site_user => site_user, :happening_page => page
end

When /I view the "(\w+)" signup page/ do |title|
  happening_page = Page.find_by_title(title)
  visits happening_page.signup_page.url
end

When /I visit the "(\w+)" my-page/ do |title|
  happening_page = Page.find_by_title(title)
  visits happening_page.attendance_page.url
end

When /I follow the "(\w+)" signup link for "(\w+)"/ do |title, site_user_name|
  happening_page = Page.find_by_title(title)
  site_user = SiteUser.find_by_name(site_user_name)
  visits happening_page.signup_page.url + "?activation_code=#{site_user.activation_code}"
end

When /I fill in personal info for "(\w+)"/ do |name|
  fills_in 'Name', :with => name
  # fills_in 'Company', :with => 'My Company'
  fills_in 'Email', :with => "#{name.downcase}@test.com"
  begin
    fills_in 'Password', :with => "password"
  rescue
    fills_in 'Choose Password', :with => "password"
  end
  fills_in 'Confirm Password', :with => "password"
  fills_in 'Billing address', :with => "#{name} street"
  fills_in 'ZIP code', :with => '6543'
  fills_in 'City', :with => "#{name} town"
end
