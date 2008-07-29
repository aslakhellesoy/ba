require File.dirname(__FILE__) + '/../spec_helper'

describe PresentationPage do
  before do
    @happening  = HappeningPage.create! :title => 't', :slug => 's', :breadcrumb => 'b', :starts_at => Time.now
  end
  
  describe 'one in program and one outside' do
    before do
      @old_presentation = PresentationPage.create! :body => 'Old', :title => 'Old', :parent_id => @happening.id
      @new_presentation = PresentationPage.create! :body => 'New', :title => 'New', :parent_id => @happening.id

      @old_presentation.program_slot = '88'
      @old_presentation.save!
    end
    
    it "should have old published" do
      @old_presentation.should be_published
    end

    it "should have new draft" do
      @new_presentation.should_not be_published
    end

    it "should put other presentation back in draft and clear its slot when taking its slot" do
      @new_presentation.program_slot = '88'
      @new_presentation.save!
      
      @new_presentation.program_slot.should == '88'
      @new_presentation.should be_published
    
      @old_presentation.reload
    
      @old_presentation.program_slot.should be_nil
      @old_presentation.should_not be_published
    end
  end
end