require File.dirname(__FILE__) + '/../spec_helper'

describe Attendance do
  before do
    @happening = HappeningPage.create! :title => 't', :slug => 's', :breadcrumb => 'b', :starts_at => Time.now
    @site_user = SiteUser.new :name => 'New SiteUser', :login => 'newsite_user', :password => 'password', :password_confirmation => 'password', :email => 'aslak.hellesoy@gmail.com'
  end
  
  it "should create an active site_user when it's new and valid" do
    attendance = Attendance.new
    attendance.site_user = @site_user
    attendance.happening_page = @happening
    attendance.save!
    site_user = SiteUser.find_by_name('New SiteUser')
    
    site_user.state.should == "active"
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

  it "should add a draft presentation page under happening when new presentation is added" do
    attendance = Attendance.create! :site_user => @site_user, :happening_page => @happening
    presentation_page = attendance.new_presentation = PresentationPage.new(:title => "Title", :body => "Body")
    presentation_page.save!
    presentation_page.parent.should == @happening
    presentation_page.status.symbol.should == :draft
    presentation_page.part('body').content.should == "Body"
  end

end