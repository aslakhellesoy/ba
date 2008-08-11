# This mailer can send email to one or more users. The from address, subject and body are taken
# from the part - see FORMAT_HELP
class SiteUserMailer < ActionMailer::Base
  FORMAT_HELP = %{
Email parts must be formatted as follows:

From: "Someone" <someone@somewhere.com>
Subject: Some subject

BODY

The Body can be of any length, and must follow one line under the headers. 
The sent email's content type will be text/plain or text/html based on the filter of the part.

Attachments are not supported yet. Your email was:

}

  def self.mass_mail(email)
    site_users = SiteUser.find(email[:site_user_id])
    site_users.each do |site_user|
      part = PagePart.new :content => %{From: #{email[:from]}
Subject: #{email[:subject]}

#{email[:body]}}
      deliver_part(part, site_user)
    end
    site_users.length
  end

  # deliver_part
  def part(email_part, site_user)
    @from, @subject, email_part.content = split_fields(email_part.content)
    @body = parse_part(email_part, site_user)
    @recipients   = "#{site_user.email}"
    @sent_on      = Time.now
    @content_type = 'text/html' unless email_part.filter.class == TextFilter
  end
  
private

  def parse_part(part, site_user)
    context = Radius::Context.new
    context.globals.site_user = site_user
    context.extend(BaTags)

    parser = Radius::Parser.new(context, :tag_prefix => 'r')
    text = part.content
    text = parser.parse(text)
    text = part.filter.filter(text) if part.respond_to? :filter_id
    text
  end  
  
  def split_fields(text)
    fields = []
    lines = text.split("\n")
    if lines[0] =~ /From:(.*)/
      fields << $1.strip
    else
      raise_help(text)
    end
    if lines[1] =~ /Subject:(.*)/
      fields << $1.strip
    else
      raise_help(text)
    end
    fields << lines[3..-1].join("\n")
    raise_help(text) if fields[2].blank?
    fields
  end
  
  def raise_help(text)
    raise FORMAT_HELP + text
  end
end
