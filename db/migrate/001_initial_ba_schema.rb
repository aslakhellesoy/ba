class InitialBaSchema < ActiveRecord::Migration
  def self.up
    add_column :pages, :starts_at, :datetime
    add_column :pages, :ends_at, :datetime
    add_column :pages, :max_attendants, :integer
    add_column :pages, :price_id, :integer

    create_table "attendances", :force => true do |t|
      t.integer  "user_id"
      t.integer  "page_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "price_id"
    end

    create_table "presentations", :force => true do |t|
      t.string   "title"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "presenters", :force => true do |t|
      t.integer  "presentation_id"
      t.integer  "attendance_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "prices", :force => true do |t|
      t.integer  "amount"
      t.string   "currency"
      t.string   "code"
      t.integer  "max"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
  
  def self.down
    drop_table "prices"
    drop_table "presenters"
    drop_table "presentations"
    drop_table "attendances"

    remove_column :pages, :price_id
    remove_column :pages, :max_attendants
    remove_column :pages, :ends_at
    remove_column :pages, :starts_at
  end
end