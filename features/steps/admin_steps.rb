Given "I am logged into Radiant" do
  u = User.create! :name => 'Administrator', :login => 'admin', :password => 'radiant', :password_confirmation => 'radiant' 
  visits '/admin/login'
  fills_in "Username", :with => 'admin'
  fills_in "Password", :with => 'radiant'
  clicks_button "Login"
end