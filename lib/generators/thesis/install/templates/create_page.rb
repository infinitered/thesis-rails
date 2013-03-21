class CreatePage < ActiveRecord::Migration
  def self.up
    create_table :page do |t|
      t.string  :name
      t.string  :description
      t.boolean :published      
      t.timestamps
    end
  end

  def self.down
    drop_table :page
  end
end