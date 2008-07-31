require File.dirname(__FILE__) + '/../spec_helper'

# class TMail::Mail
#   def index(*a)
#     0
#   end
# end

describe SiteUserMailer do
  it "should send plain text email" do
    user = User.new :email => 'user@test.com'
    part = PagePart.new :content => %{From: sender@test.com
Subject: Welcome to the pleasurdome

Relax,
don't do it}

    tmail = SiteUserMailer.create_part(part, user)
    tmail.from.should         == ['sender@test.com']
    tmail.subject.should      == 'Welcome to the pleasurdome'
    tmail.body.should         == "Relax,\ndon't do it"
    tmail.destinations.should == ['user@test.com']
    tmail.content_type.should == 'text/plain'
  end

    it "should send HTML text email for Textile" do
      user = User.new :email => 'user@test.com'
      part = PagePart.new :content => %{From: sender@test.com
Subject: Welcome to the pleasurdome

h1. Relax,

don't do it}
      part.filter_id = 'Textile'

      tmail = SiteUserMailer.create_part(part, user)
      tmail.from.should         == ['sender@test.com']
      tmail.subject.should      == 'Welcome to the pleasurdome'
      tmail.body.should         == "<h1>Relax,</h1>\n\n\n\t<p>don&#8217;t do it</p>"
      tmail.destinations.should == ['user@test.com']
      tmail.content_type.should == 'text/html'
    end
end