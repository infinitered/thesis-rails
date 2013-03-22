class CreatePage < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :parent_id
      t.string  :name
      t.string  :slug
      t.string  :description
      t.integer :sort_order, default: 0, null: false
      t.string  :template, default: "default", null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end