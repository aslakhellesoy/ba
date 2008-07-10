# Make sure Radiant's RSpec is used instead of RSpec gem
$:.unshift File.dirname(__FILE__) + '/../../../../plugins/rspec/lib'
$:.unshift File.dirname(__FILE__) + '/../../../../plugins/rspec_on_rails/lib'
$:.unshift File.dirname(__FILE__) + '/../../../../plugins/cucumber/lib'

namespace :radiant do
  namespace :extensions do
    namespace :ba do
      
      desc "Runs the migration of the Ba extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          BaExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          BaExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Ba to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[BaExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(BaExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  

      require 'cucumber/rake/task'
      Cucumber::Rake::Task.new do |t|
        t.story_pattern = File.dirname(__FILE__) + '/../../stories/**/*.story'
        t.step_pattern = File.dirname(__FILE__) + '/../../stories/**/*.rb'
        t.cucumber_opts = "--format pretty"
      end
      task :stories => 'db:test:prepare'
      
      require 'spec/rake/spectask'
      Spec::Rake::SpecTask.new do |t|
        t.pattern = File.dirname(__FILE__) + '/../../spec/**/*.rb'
        t.spec_opts = %w{--colour --diff}
      end
      task :spec => 'db:test:prepare'
      
      desc "Run stories and specs"
      task :stories_and_specs => [:stories, :spec]
    end
  end
end
