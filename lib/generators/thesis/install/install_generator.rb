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
        migration_template "create_page.rb", "db/migrate/create_page.rb"
        migration_template "create_page_content.rb", "db/migrate/create_page_content.rb"
      end

      def create_folders
        copy_file "page_templates/default.html.haml", "app/views/page_templates/default.html.haml" if Haml
        copy_file "page_templates/default.html.erb", "app/views/page_templates/default.html.erb" unless Haml
      end

      def set_up_routes
        route("thesis_routes # This needs to be the last route!")
      end
    end
  end
end