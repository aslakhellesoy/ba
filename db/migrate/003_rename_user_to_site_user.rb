class RenameUserToSiteUser < ActiveRecord::Migration
  def self.up
    rename_column :attendances, :user_id, :site_user_id
  end

  def self.down
    rename_column :attendances, :site_user_id, :user_id
  end
end
