class CreateLoginPage < ActiveRecord::Migration
  def self.up
    LoginPage.create!
  end

  def self.down
    LoginPage.destroy_all
  end
end