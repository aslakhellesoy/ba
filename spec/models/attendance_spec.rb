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
  end

  it "should not save anything when the user is new and invalid" do
    user = User.new :name => 'New User', :login => 'newuser', :password => 'password', :password_confirmation => 'wrong', :email => 'new@user.com'
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
  
  it "should have error on price_code when code does not exist" do
    lambda do
      Attendance.create! :user => @user, :happening_page => @happening, :price_code => 'NOPE'
    end.should raise_error
  end

  it "should create an associated presentation when new_presentation is set" do
    pending "Should pass when we refactor to restful authentication" do
      first = Presentation.new :title => "Title1", :description => "Description1"
      second = Presentation.new :title => "Title2", :description => "Description2"
      attendance = Attendance.create! :user => @user, :happening_page => @happening, :new_presentation => first
      attendance.new_presentation = second
      attendance.save!
      attendance.presentations.should == [first, second]
    end
  end

end