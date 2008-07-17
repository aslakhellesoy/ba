require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttendancesController do
  describe "responding to GET /attendances/new" do
    it "should process the page associated with url" do
      page = mock_model(Page, :cache? => true)
      page.should_receive(:controller=).with(controller)
      page.should_receive(:process).with(request, response)
      controller.should_receive(:find_page).with("foo/attendances/new").and_return(page)
      
      get :new, :url => ["foo"]
    end
  end
end