class ThesisCreatePage < ActiveRecord::Migration
  def self.up
    # Please note: if you change this (in the thesis gem) please
    # update the /spec/spec_helper.rb to match.
    
    create_table :pages do |t|
      t.integer :parent_id
      t.string  :name
      t.string  :slug
      t.string  :title
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