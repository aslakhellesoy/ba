require File.dirname(__FILE__) + '/../spec_helper'

describe "BaTags" do
  before do
    @page = Page.new(page_attrs('MyConference', '2008-07-09T02:00:00Z', '2008-07-09T05:00:00Z'))
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
  
  describe '<r:hcal>' do
    it 'should render the page details as a hCal snippet' do
      tag = '<r:hcal description="What it is" location="Where it is"></r:hcal>'

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

  describe '<r:signup>' do
    it "should render a form for signing up" do
      tag = '<r:signup></r:signup>'
      
      expected = %{<form action="/my-conference/signup/" method="post">
  <p><label for="user_name">Name</label>
  <input id="user_name" name="user[name]" size="30" type="text" /></p>

  <p><label for="user_email">Email</label>
  <input id="user_email" name="user[email]" size="30" type="text" /></p>

  <p><label for="user_login">Login</label>
  <input id="user_login" name="user[login]" size="30" type="text" /></p>

  <p><label for="user_password">Password</label>
  <input id="user_password" name="user[password]" size="30" type="text" /></p>

  <p><label for="user_password_confirmation">Confirm Password</label>
  <input id="user_password_confirmation" name="user[password_confirmation]" size="30" type="text" /></p>

  <p><input name="commit" type="submit" value="Sign up" /></p>
</form>}

      @page.parts << PagePart.new(:name => "body", :content => tag)
      @page.render.should == expected
    end
  end
end