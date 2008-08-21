# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../../config/environment') # Radiant root's env
require 'cucumber/rails/world'
require 'cucumber/rails/rspec'

Before do
  layout = Layout.create! :name => 'Normal', :content => "<html><r:content /></html>"

  @home_page = Page.create!(
    :layout => layout,
    :title => "Home Page",
    :breadcrumb => "Home Page",
    :slug => "/",
    :status => Status[:published],
    :published_at => Time.now.to_s(:db)
  )
  
  LoginPage.destroy_all
  LoginPage.create!(:layout => layout)
  AccountPage.destroy_all
  AccountPage.create!(:layout => layout)
end

ActionMailer::Base.delivery_method = :test