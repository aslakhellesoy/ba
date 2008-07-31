ActionMailer::Base.smtp_settings = {
  :address  => "localhost",
  :port  => 1234, 
  :domain  => "localhost"
}

class Mbox
end