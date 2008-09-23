class CreateForgotPasswordPage < ActiveRecord::Migration
  def self.up
    ForgotPasswordPage.create!
  end

  def self.down
    ForgotPasswordPage.destroy_all
  end
end