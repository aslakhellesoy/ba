require File.dirname(__FILE__) + '/../spec_helper'

describe "BaTags" do
  before do
    @page = HappeningPage.new(page_attrs('MyConference', '2008-07-09T02:00:00Z', '2008-07-09T05:00:00Z'))
  end
  
  def page_attrs(title, starts, ends)
    starts_at = Time.parse(starts)
    ends_at = Time.parse(ends)
    {
      :title => title,
      :breadcrumb => title,
      :slug => title.symbolize.to_s.gsub("_", "-"),
      :class_name => nil,
      :status_id => Status[:published].id,
      :published_at => Time.now.to_s(:db),
      :starts_at => starts_at,
      :ends_at => ends_at
    }
  end
  
  describe '<r:ba:hcal>' do
    it 'should render the page details as a hCal snippet' do
      tag = '<r:ba:hcal description="What it is" location="Where it is"></r:ba:hcal>'

      expected = %{<div class="vevent">
  <h3 class="summary"><a href="/my-conference/" class="url">MyConference</a></h3>
  <p class="description">What it is</p>
  <p>
    <abbr class="dtstart" title="2008-07-09T02:00:00Z">July 09, 2008 02:00</abbr>
  </p>
  <p><span class="location">Where it is</span></p>
</div>}

      @page.parts << PagePart.new(:name => "body", :content => tag)
      @page.render.should == expected
    end
  end
end