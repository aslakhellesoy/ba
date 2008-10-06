Then /I should receive a (.*) representation/ do |mime_type|
  response.headers['type'].should == mime_type
end