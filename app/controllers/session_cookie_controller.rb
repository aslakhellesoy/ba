# Baseclass for all Ba controllers that use a cookie-based session
class SessionCookieController < ActionController::Base
  include AuthenticatedSystem
end