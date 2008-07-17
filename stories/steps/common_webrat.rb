When /I press "(.*)"/ do |button|
  clicks_button(button)
end

Then /I should be see "(.*)"/ do |text|
  response.body.should =~ /#{text}/m
end