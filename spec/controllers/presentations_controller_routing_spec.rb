require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PresentationsController do
  def verify_both_ways(verb, path, params)
    params_from(verb, path).should == params
    route_for(params).should == path
  end
  
  it "should map #create" do
    verify_both_ways(:post, "/foo/bar/attendances/45/presentations",
      :controller => "presentations", :action => "create", :attendance_id => "45", :url => ["foo", "bar"])
  end

  it "should map #show" do
    verify_both_ways(:get, "/presentations/76", 
      :controller => "presentations", :action => "show", :id => "76")
  end
end
