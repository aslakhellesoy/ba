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
      Cucumber::Rake::Task.new(:features) do |t|
        t.feature_pattern = File.dirname(__FILE__) + '/../../features/**/*.feature'
        t.step_pattern = File.dirname(__FILE__) + '/../../features/**/*.rb'
        t.cucumber_opts = "--format pretty"
      end
      task :features => 'db:test:prepare'
      
      require 'spec/rake/spectask'
      Spec::Rake::SpecTask.new do |t|
        t.pattern = File.dirname(__FILE__) + '/../../spec/**/*.rb'
        t.spec_opts = %w{--colour --diff}
      end
      task :spec => 'db:test:prepare'
      
      desc "Run stories and specs"
      task :features_and_specs => [:features, :spec]
      
      desc "Start a local SMTP server for testing"
      task :smtp_server do
        a = SMTPServer.new(1234)
        a.start
        a.join
      end
    end
  end
end

require 'gserver'

class SMTPServer < GServer
  def serve(io)
    @data_mode = false
    puts "Connected"
    io.print "220 hello\r\n"
    loop do
      if IO.select([io], nil, nil, 0.1)
	      data = io.readpartial(4096)
	      puts ">>" + data
	      ok, op = process_line(data)
	      break unless ok
	      io.print op
      end
      break if io.closed?
    end
    io.print "221 bye\r\n"
    io.close
  end

  def process_line(line)
    if (line =~ /^(HELO|EHLO)/)
      return true, "220 and..?\r\n"
    end
    if (line =~ /^QUIT/)
      return false, "bye\r\n"
    end
    if (line =~ /^MAIL FROM\:/)
      return true, "220 OK\r\n"
    end
    if (line =~ /^RCPT TO\:/)
      return true, "220 OK\r\n"
    end
    if (line =~ /^DATA/)
      @data_mode = true
      return true, "354 Enter message, ending with \".\" on a line by itself\r\n"
    end
    if (@data_mode) && (line.chomp =~ /^.$/)
      @data_mode = false
      return true, "220 OK\r\n"
    end
    if @data_mode
      puts line 
      return true, ""
    else
      return true, "500 ERROR\r\n"
    end
  end
end
