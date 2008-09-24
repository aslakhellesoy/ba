class AddPasswordResetCode < ActiveRecord::Migration
  def self.up
    add_column :site_users, :reset_code, :string
  end
  
  def self.down
    remove_column :site_users, :reset_code
  end
end
