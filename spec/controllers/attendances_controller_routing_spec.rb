require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttendancesController do
  describe "route generation" do
    it "should map #new" do
      route_for(:controller => "attendances", :action => "new").should == "/attendance/new"
    end
  
    it "should map #show" do
      route_for(:controller => "attendances", :action => "show").should == "/attendance"
    end
  
    it "should map #edit" do
      route_for(:controller => "attendances", :action => "edit").should == "/attendance/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "attendances", :action => "update").should == "/attendance"
    end
  
    it "should map #destroy" do
      route_for(:controller => "attendances", :action => "destroy").should == "/attendance"
    end
  end

  describe "route generation with url prefix" do
    it "should map #new" do
      route_for(:controller => "attendances", :action => "new", :url => ["foo", "bar"]).should == "/foo/bar/attendance/new"
    end
  end

  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/attendance/new").should == {:controller => "attendances", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/attendance").should == {:controller => "attendances", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/attendance").should == {:controller => "attendances", :action => "show"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/attendance/edit").should == {:controller => "attendances", :action => "edit"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/attendance").should == {:controller => "attendances", :action => "update"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/attendance").should == {:controller => "attendances", :action => "destroy"}
    end
  end

  describe "route recognition with url prefix" do
    it "should generate params for #show" do
      params_from(:get, "/foo/attendance").should == {:controller => "attendances", :action => "show", :url => ["foo"]}
    end
  end
end
