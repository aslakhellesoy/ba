require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttendancesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "attendances", :action => "index").should == "/attendances"
    end
  
    it "should map #new" do
      route_for(:controller => "attendances", :action => "new").should == "/attendances/new"
    end
  
    it "should map #show" do
      route_for(:controller => "attendances", :action => "show", :id => 1).should == "/attendances/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "attendances", :action => "edit", :id => 1).should == "/attendances/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "attendances", :action => "update", :id => 1).should == "/attendances/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "attendances", :action => "destroy", :id => 1).should == "/attendances/1"
    end
  end

  describe "route generation with url prefix" do
    it "should map #index" do
      route_for(:controller => "attendances", :action => "index", :url => ["foo", "bar"]).should == "/foo/bar/attendances"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/attendances").should == {:controller => "attendances", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/attendances/new").should == {:controller => "attendances", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/attendances").should == {:controller => "attendances", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/attendances/1").should == {:controller => "attendances", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/attendances/1/edit").should == {:controller => "attendances", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/attendances/1").should == {:controller => "attendances", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/attendances/1").should == {:controller => "attendances", :action => "destroy", :id => "1"}
    end
  end

  describe "route recognition with url prefix" do
    it "should generate params for #index" do
      params_from(:get, "/foo/attendances").should == {:controller => "attendances", :action => "index", :url => ["foo"]}
    end
  end
end
