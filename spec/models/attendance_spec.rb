require File.dirname(__FILE__) + '/../spec_helper'

describe Attendance do
  before do
    @happening = HappeningPage.create! :title => 't', :slug => 's', :breadcrumb => 'b', :starts_at => Time.now
    @site_user = SiteUser.new :name => 'New SiteUser', :login => 'newsite_user', :password => 'password', :password_confirmation => 'password', :email => 'aslak.hellesoy@gmail.com'
  end
  
  it "should save the site_user when it's new and valid" do
    attendance = Attendance.new
    attendance.site_user = @site_user
    attendance.happening_page = @happening
    attendance.save!
    SiteUser.find_by_name('New SiteUser').should_not be_nil
  end

  it "should not save anything when the site_user is new and invalid" do
    site_user = SiteUser.new :name => 'New SiteUser', :login => 'newsite_user', :password => 'password', :password_confirmation => 'wrong', :email => 'new@site_user.com'
    attendance = Attendance.new
    attendance.site_user = site_user
    attendance.happening_page = @happening
    attendance.save.should == false
  end
  
  it "should assign a price when price_code available" do
    price = @happening.prices.create! :code => 'CHEAP'
    attendance = Attendance.create! :site_user => @site_user, :happening_page => @happening, :price_code => 'CHEAP'
    attendance.price.should == price
  end
  
  it "should have error on price_code when code does not exist" do
    lambda do
      Attendance.create! :site_user => @site_user, :happening_page => @happening, :price_code => 'NOPE'
    end.should raise_error
  end

  it "should create an associated presentation when new_presentation is set" do
    first = Presentation.new :title => "Title1", :description => "Description1"
    second = Presentation.new :title => "Title2", :description => "Description2"
    attendance = Attendance.create! :site_user => @site_user, :happening_page => @happening, :new_presentation => first
    attendance.new_presentation = second
    attendance.save!
    attendance.presentations.should == [first, second]
  end

end