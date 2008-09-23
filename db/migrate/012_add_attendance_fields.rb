class AddAttendanceFields < ActiveRecord::Migration
  def self.up
    add_column :attendances, :dinner, :boolean
    add_column :attendances, :comment, :text
  end
  
  def self.down
    remove_column :attendances, :comment
    remove_column :attendances, :dinner
  end
end