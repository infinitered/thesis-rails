class CreatePage < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :parent_id
      t.string  :name
      t.string  :slug
      t.string  :description
      t.boolean :published      
      t.integer :sort_order
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end