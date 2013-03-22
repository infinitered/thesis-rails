class CreatePageContent < ActiveRecord::Migration
  def self.up
    create_table :page_contents do |t|
      t.integer :page_id, null: false
      t.text    :content
      t.string  :type
      t.timestamps
    end
  end

  def self.down
    drop_table :page_contents
  end
end