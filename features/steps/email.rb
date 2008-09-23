Given /I am on the mass mailing page/ do
  visits "/admin/email/new"
end

Then /"(\w+)" should receive an email with activation code/ do |site_user_name|
  user = SiteUser.find_by_name(site_user_name)
  user.activation_code.should_not be_blank
  sent = ActionMailer::Base.deliveries.select do |email|
    email.to.index(user.email)
  end.last
  raise "There were no emails for #{user.email}" if sent.nil?
  sent.body.should =~ /#{user.activation_code}/
end

Then /"([^"]+)" should receive an email with "([^"]+)"/ do |site_user_name, email_body|
  user = SiteUser.find_by_name(site_user_name)
  raise "No such user: #{site_user_name}" if user.nil?
  sent = ActionMailer::Base.deliveries.select do |email|
    email.to.index(user.email)
  end.last
  raise "There were no emails for #{user.email}" if sent.nil?
  sent.body.should =~ /#{email_body}/
end

Then /"(\w+)" should receive an email with reset code/ do |site_user_name|
  user = SiteUser.find_by_name(site_user_name)
  raise "No such user: #{site_user_name}" if user.nil?
  sent = ActionMailer::Base.deliveries.select do |email|
    email.to.index(user.email)
  end.last
  sent.body.should =~ /Follow this link/m
end

Then /"(\w+)" should not receive any email/ do |site_user_name|
  user = SiteUser.find_by_name(site_user_name)
  sent = ActionMailer::Base.deliveries.select do |email|
    email.to.index(user.email)
  end
  sent.should be_empty
end

When /I follow the link in "(\w+)"'s reset password email/ do |site_user_name| #'
  user = SiteUser.find_by_name(site_user_name)
  sent = ActionMailer::Base.deliveries.select do |email|
    email.to.index(user.email)
  end
  
  if sent.to_s =~ /Follow this link: http:\/\/example.com(.*)$/
    visits $1
  else
    raise "Couldn't find a reset link in the mail:\n#{sent}"
  end
end
