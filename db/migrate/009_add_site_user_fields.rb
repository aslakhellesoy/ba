class AddSiteUserFields < ActiveRecord::Migration
  def self.up
    add_column :site_users, :phone_number, :string
    add_column :site_users, :title, :string
    add_column :site_users, :role, :string
    add_column :site_users, :company, :string
    add_column :site_users, :billing_address, :string
    add_column :site_users, :billing_area_code, :string
    add_column :site_users, :billing_city, :string
    add_column :site_users, :nomail, :boolean
  end
  
  def self.down
    remove_column :site_users, :phone_number
    remove_column :site_users, :title
    remove_column :site_users, :role
    remove_column :site_users, :company
    remove_column :site_users, :billing_address
    remove_column :site_users, :billing_area_code
    remove_column :site_users, :billing_city
    remove_column :site_users, :nomail
  end
end