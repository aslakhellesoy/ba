When /I press "(.*)"/ do |button|
  clicks_button(button)
end

When /I fill in "(.*)" for "(.*)"/ do |value, field|
  fills_in(field, :with => value) 
end

When /I check "(.*)"/ do |field|
  checks(field) 
end

Then /I should see "(.*)"/ do |text|
  response.body.should =~ /#{text}/m
end