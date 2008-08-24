class CreateLoginPage < ActiveRecord::Migration
  def self.up
    begin
      home_page = Page.create!(
        :title => "Home Page",
        :breadcrumb => "Home Page",
        :slug => "/",
        :status => Status[:published],
        :published_at => Time.now.to_s(:db)
      )
    rescue => e
      puts e.message
      puts e.backtrace
      raise e
      # It already exists...
    end

    LoginPage.create!
  end

  def self.down
    LoginPage.destroy_all
  end
end