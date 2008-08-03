# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../config/environment') # Radiant root's env
require 'cucumber/rails/world'

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
end

Dir[File.dirname(__FILE__) + '/../vendor/plugins/*'].each do |plugin|
  $:.unshift(File.join(plugin, 'lib'))
  init = File.join(plugin, 'init.rb')
  load init if File.file?(init)
end

ActionMailer::Base.delivery_method = :test