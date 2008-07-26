class PresentationsController < ApplicationController
  session :disabled => false
  no_login_required
end