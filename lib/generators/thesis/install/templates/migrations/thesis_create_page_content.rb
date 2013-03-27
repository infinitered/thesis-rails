class ThesisCreatePageContent < ActiveRecord::Migration
  def self.up
    # Please note: if you change this (in the thesis gem) please
    # update the /spec/spec_helper.rb to match.
    
    create_table :page_contents do |t|
      t.integer :page_id,           null: false
      t.string  :name,              null: false
      t.text    :content,           default: "Edit This Content Area"
      t.string  :content_type,      default: :html
      t.timestamps
    end
  end

  def self.down
    drop_table :page_contents
  end
end