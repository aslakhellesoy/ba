# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../config/environment') # Radiant root's env
require 'cucumber/rails/world'

Dir[File.dirname(__FILE__) + '/../vendor/plugins/*'].each do |plugin|
  $:.unshift(File.join(plugin, 'lib'))
  init = File.join(plugin, 'init.rb')
  load init if File.file?(init)
end

ActionMailer::Base.delivery_method = :test