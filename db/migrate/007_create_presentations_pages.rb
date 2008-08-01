class CreatePresentationsPages < ActiveRecord::Migration
  def self.up
    Page.find_all_by_class_name('HappeningPage').each do |h|
      PresentationsPage.create :parent => h
    end
  end

  def self.down
  end
end
