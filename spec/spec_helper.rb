require 'rubygems'
require 'bundler/setup'
require 'factory_girl'
require 'rspec/autorun'
require 'database_cleaner'
require 'rails/all'

# Add a fake ApplicationController for testing.
class ApplicationController < ActionController::Base
  def page_is_editable?(page)
    true
  end
end

# Require thesis
require "thesis"

# Manually run the Rails initializer. Thanks to @JoshReedSchramm for the code.
initializer = Thesis::Engine.initializers.select { |i| i.name == "thesis.action_controller" }.first
initializer.run
# Dir[File.join('.', '/lib/thesis/**/*.rb')].each {|file| require file }

# Load Factories
FactoryGirl.find_definitions

# Configure ActiveRecord Connection
# Use memory store since we don't care about persistent data here.
ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

# Configure ActiveRecord Testing Schema
ActiveRecord::Schema.define do
  self.verbose = false

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

  create_table :page_contents do |t|
    t.integer :page_id,           null: false
    t.string  :name,              null: false
    t.text    :content,           default: "Edit This Content Area"
    t.string  :content_type,      default: :html
    t.timestamps
  end
end

RSpec.configure do |config|
  # Pretty FactoryGirl syntax. For more details, visit
  # https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#using-factories
  config.include FactoryGirl::Syntax::Methods

	DatabaseCleaner.strategy = :transaction

	# Configure DatabaseCleaner to set up a new
	# transaction at the beginning of each test.
	config.before do
		DatabaseCleaner.start
	end

	# Reload FactoryGirl definitions and clean
	# the database after every test.
  config.after do
    FactoryGirl.reload
		DatabaseCleaner.clean
  end
end
