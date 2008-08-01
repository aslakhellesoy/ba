class RemoveSiteUserLogin < ActiveRecord::Migration
  def self.up
    remove_index :site_users, :login
    remove_column :site_users, :login
  end

  def self.down
    add_column :site_users, :login, :string, :limit => 40
    add_index :site_users, :login, :unique => true
  end
end