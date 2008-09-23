# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../../config/environment') # Radiant root's env
require 'cucumber/rails/world'
require 'cucumber/rails/rspec'
Cucumber::Rails.use_transactional_fixtures