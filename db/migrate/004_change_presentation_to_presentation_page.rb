class ChangePresentationToPresentationPage < ActiveRecord::Migration
  def self.up
    drop_table :presentations
    rename_column :presenters, :presentation_id, :presentation_page_id
  end

  def self.down
    rename_column :presenters, :presentation_page_id, :presentation_id
    create_table :presentations do |t|
      t.string   "title"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
