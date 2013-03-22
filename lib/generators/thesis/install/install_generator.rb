require 'rails/generators/migration'

module Thesis
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      
      source_root File.expand_path('../templates', __FILE__)
      
      desc "install or upgrade Thesis"
      
      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template "migrations/create_page.rb", "db/migrate/create_page.rb"
        migration_template "migrations/create_page_content.rb", "db/migrate/create_page_content.rb"
      end

      def create_folders
        copy_file "page_templates/default.html.haml", "app/views/page_templates/default.html.haml" if Haml
        copy_file "page_templates/default.html.erb", "app/views/page_templates/default.html.erb" unless Haml
      end

      def set_up_routes
        route "thesis_routes # This needs to be the last route!"
      end

      def install_js
        insert_into_file "app/assets/javascripts/application.js", after: %r{//= require +['"]?jquery_ujs['"]?} do
          "\n//= require jquery-ui" +
          "\n//= require thesis"
        end
      end

      def complete_message
        require "thesis/colorizer"

        if generating?
          puts "  "
          puts "  Thesis installed.".green
          puts "  Now run `rake db:migrate` to set up your database.".pink
        else
          puts "  "
          puts "  Thesis uninstalled.".red
          puts "  You will need to remove the database tables manually if you've already run `rake db:migrate`.".pink
        end
      end

    protected

      def generating?
        :invoke == behavior
      end

      def destroying?
        :revoke == behavior
      end  
    end
  end
end