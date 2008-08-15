class RemoveMaxAttendantsAndAddPriceCopy < ActiveRecord::Migration
  def self.up
    remove_column :pages, :max_attendants

    add_column :attendances, :amount, :integer
    add_column :attendances, :currency, :string
  end
  
  def self.down
    remove_column :attendances, :amount
    remove_column :attendances, :currency

    add_column :pages, :max_attendants, :integer
  end
end