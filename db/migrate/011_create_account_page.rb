class CreateAccountPage < ActiveRecord::Migration
  def self.up
    AccountPage.create!
  end

  def self.down
    AccountPage.destroy_all
  end
end