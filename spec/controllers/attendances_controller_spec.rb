require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttendancesController do
  describe "responding to GET /attendance" do
    it "should process the page associated with url" do
      page = mock_model(Page, :cache? => true, :published? => true)
      page.should_receive(:controller=).with(controller)
      page.should_receive(:process).with(request, response)
      Page.should_receive(:find_by_url).with("/foo/attendance", true).and_return(page)
      
      get :show, :url => ["foo"]
    end
  end
end