require File.dirname(__FILE__) + '/../spec_helper'

describe Attendance do
  it "should save the user when it's new and valid" do
    user = User.new :name => 'New User', :login => 'newuser', :password => 'password', :password_confirmation => 'password', :email => 'new@user.com'
    attendance = Attendance.new
    attendance.user = user
    attendance.save!
    User.find_by_name('New User').should_not be_nil
  end

  it "should not save anything when the user is new and invalid" do
    user = User.new :name => 'New User', :login => 'newuser', :password => 'password', :email => 'new@user.com'
    attendance = Attendance.new
    attendance.user = user
    attendance.save.should == false
  end
end