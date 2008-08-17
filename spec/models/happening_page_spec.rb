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
end