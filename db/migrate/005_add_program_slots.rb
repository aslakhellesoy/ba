class AddProgramSlots < ActiveRecord::Migration
  def self.up
    add_column :pages, :program_slot, :string
  end
  
  def self.down
    remove_column :pages, :program_slot
  end
end