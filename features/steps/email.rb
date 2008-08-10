Then /"([^"]+)" should receive an email with "([^"]+)"/ do |site_user_name, email_body|
  sent = ActionMailer::Base.deliveries.last
  user = SiteUser.find_by_name(site_user_name)
  sent.to.should include(user.email)
  sent.body.should =~ /#{email_body}/
end
