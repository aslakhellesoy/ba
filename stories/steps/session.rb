Given "I am logged in" do
  User.create! :name => 'Organizer', :login => 'organizer', :password => 'password', :password_confirmation => 'password'
  
  visits '/admin/login'
  fills_in 'Username', :with => 'organizer'
  fills_in 'Password', :with => 'password'
  clicks_button 'Login'
end