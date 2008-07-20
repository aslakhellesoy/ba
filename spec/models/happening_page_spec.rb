require File.dirname(__FILE__) + '/../spec_helper'

describe HappeningPage do
  before do
    @happening  = HappeningPage.create! :title => 't', :slug => 's', :breadcrumb => 'b', :starts_at => Time.now
    @happening2 = HappeningPage.create! :title => 'tt', :slug => 'ss', :breadcrumb => 'bb', :starts_at => Time.now
  end

  it "should have codeless price as default" do
    sponsor = @happening.prices.create! :code => 'SPON', :amount => 150
    default = @happening.prices.create! :code => '', :amount => 200
    student = @happening.prices.create! :code => 'STUD', :amount => 100
    
    @happening.default_price.should == default
  end

  it "should not allow more than one default price" do
    default = @happening.prices.create! :code => '', :amount => 200
    lambda do
      @happening.prices.create! :code => '', :amount => 200
    end.should raise_error

    @happening.default_price.should == default
  end

  it "should allow one default price per happening" do
    default = @happening.prices.create! :code => '', :amount => 200
    default2 = @happening2.prices.create! :code => '', :amount => 400

    @happening.default_price.should == default
    @happening2.default_price.should == default2
  end
  
  it "should have default parts upon creation" do
    @happening.should have(4).parts
  end

  it "should have default parts upon creation via Page class" do
    happening = Page.create! :class_name => 'HappeningPage', :title => 'pt', :slug => 'ps', :breadcrumb => 'pb', :starts_at => Time.now
    happening.should have(4).parts

    happening.reload
    happening.part('attendances/new').content.should == %{h2. Please sign up below

<r:ba:signup />}
  end
end