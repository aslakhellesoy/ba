require File.dirname(__FILE__) + '/../spec_helper'

describe Attendance do
  before do
    @happening = HappeningPage.create! :title => 't', :slug => 's', :breadcrumb => 'b', :starts_at => Time.now
    @user = User.new :name => 'New User', :login => 'newuser', :password => 'password', :password_confirmation => 'password', :email => 'new@user.com'
  end
  
  it "should save the user when it's new and valid" do
    attendance = Attendance.new
    attendance.user = @user
    attendance.happening_page = @happening
    attendance.save!
    User.find_by_name('New User').should_not be_nil
    
    attendance.reload
    attendance.happening_page.should == @happening
  end

  it "should not save anything when the user is new and invalid" do
    user = User.new :name => 'New User', :login => 'newuser', :password => 'password', :email => 'new@user.com'
    attendance = Attendance.new
    attendance.user = user
    attendance.happening_page = @happening
    attendance.save.should == false
  end
  
  it "should assign a price when price_code available" do
    price = @happening.prices.create! :code => 'CHEAP'
    attendance = Attendance.create! :user => @user, :happening_page => @happening, :price_code => 'CHEAP'
    attendance.price.should == price
  end
end