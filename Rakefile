require "bundler/gem_tasks"

# Run `rake db:migrate:thesis` to create the tables.
namespace :db do
  namespace :migrate do
    description = "Migrate the database through scripts in <gem name>/db/migrate and update db/schema.rb by invoking db:schema:dump. Target specific version with VERSION=x. Turn off output with VERBOSE=false."

    desc description
    task :thesis => :environment do
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      if Gem.searcher.find('<gem name>')
        dir = "#{Gem.searcher.find('thesis').full_gem_path}/db/migrate/"
        ActiveRecord::Migrator.migrate(dir, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      else
        raise "Unable to locate <gem name> gem to run admin migrations"
      end
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end
  end
end
