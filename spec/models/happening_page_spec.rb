require File.dirname(__FILE__) + '/../spec_helper'

describe HappeningPage do
  before do
    @happening  = Page.find(Page.create!(:class_name => 'HappeningPage', :title => 't', :slug => 's', :breadcrumb => 'b', :starts_at => Time.now).id)
    @happening2 = Page.find(Page.create!(:class_name => 'HappeningPage', :title => 'tt', :slug => 'ss', :breadcrumb => 'bb', :starts_at => Time.now).id)
  end

  it "should have codeless price as default" do
    @happening.default_price.should_not be_nil
    @happening.prices.should == [@happening.default_price]
  end

  it "should not allow more than one default price" do
    lambda do
      @happening.prices.create! :code => '', :amount => 200
    end.should raise_error
  end

  it "should have default parts upon creation" do
    @happening.should have(1).parts
  end

  it "should have signup page upon creation" do
    @happening.signup_page.class.should == SignupPage
  end
  
  it "should have attendance page upon creation" do
    @happening.attendance_page.class.should == AttendancePage
  end
  
  it "should have edit presentation page upon creation" do
    @happening.edit_presentation_page.class.should == EditPresentationPage
  end
  
  it "should move presentation under happenings for migration 007" do
    presentation = PresentationPage.create! :title => 'title', :body => 'body', :parent => @happening
    @happening.presentations_page.destroy
    p2 = PresentationsPage.create! :parent => @happening
    presentation.reload
    presentation.parent.should == p2
  end

  it "should create a per-day trend report of new attendances" do
    users = (0...14).map do |n|
      create_site_user(:email => "user#{n}@email.com")
    end
    
    Attendance.create!(:created_at => Time.parse('2007-09-01 13:00 UTC').utc, :site_user => users[0], :happening_page => @happening)

    Attendance.create!(:created_at => Time.parse('2007-09-02 13:00 UTC').utc, :site_user => users[1], :happening_page => @happening)
    Attendance.create!(:created_at => Time.parse('2007-09-02 14:00 UTC').utc, :site_user => users[2], :happening_page => @happening)
    Attendance.create!(:created_at => Time.parse('2007-09-02 15:00 UTC').utc, :site_user => users[3], :happening_page => @happening)

    Attendance.create!(:created_at => Time.parse('2007-09-03 13:00 UTC').utc, :site_user => users[4], :happening_page => @happening)
    Attendance.create!(:created_at => Time.parse('2007-09-03 14:00 UTC').utc, :site_user => users[5], :happening_page => @happening)
    
    trend = @happening.attendance_trend
    trend.should == [
      [Time.parse('2007-09-01 12:00 UTC').utc.midnight, 1],
      [Time.parse('2007-09-02 12:00 UTC').utc.midnight, 4],
      [Time.parse('2007-09-03 12:00 UTC').utc.midnight, 6]
    ]
  end

  def create_site_user(options = {})
    record = SiteUser.new({ :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69',
      :billing_address => 'Street', :billing_area_code => '0000', :billing_city => 'City' }.merge(options))
    record.register! if record.valid?
    record
  end
end