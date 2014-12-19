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
        copy_migration "thesis_create_page"
        copy_migration "thesis_create_page_content"
      end

      def create_folders
        return copy_file "page_templates/default.html.slim", "app/views/page_templates/default.html.slim" if defined? Slim
        return copy_file "page_templates/default.html.haml", "app/views/page_templates/default.html.haml" if defined? Haml
        copy_file "page_templates/default.html.erb", "app/views/page_templates/default.html.erb"
      end

      def install_js
        filename = "app/assets/javascripts/application.js"
        existing = File.binread("#{filename}").include?("require thesis")

        if existing && generating?
          say_status("skipped", "insert into #{filename}", :yellow)
        else
          insert_into_file "#{filename}", after: %r{//= require +['"]?jquery_ujs['"]?} do
            "\n//= require jquery-ui" +
            "\n//= require thesis"
          end
        end
      end

      def install_css
        filename = "app/assets/stylesheets/application.css"
        filename = filename << ".scss" unless File.exists? filename
        if File.exists? filename
          existing = File.binread("#{filename}").include?("require thesis")

          if existing && generating?
            say_status("skipped", "insert into #{filename}", :yellow)
          else
            insert_into_file "#{filename}", after: %r{ *= require_self} do
              "\n *= require thesis"
            end
          end
        else
          say_status("skipped", "Couldn't insert into #{filename} -- doesn't exist")
        end
      end

      def install_page_is_editable
        filename = "app/controllers/application_controller.rb"
        existing = File.binread("#{filename}").include?("def page_is_editable?")

        if existing && generating?
          say_status("skipped", "insert into #{filename}", :yellow)
        else
          insert_into_file "#{filename}", after: %r{  protect_from_forgery with: :exception} do
            "\n" +
            "\n  # Thesis authentication" +
            "\n  def page_is_editable?(page)" +
            "\n    # Add your own criteria here for editing privileges. Examples:" +
            "\n    # current_user.admin? # Basic admin" +
            "\n    # can? :update, page # CanCan" +
            "\n    true # EVERYONE has access right now." +
            "\n  end"
          end
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

      def copy_migration(filename)
        if generating? && self.class.migration_exists?("db/migrate", "#{filename}")
          say_status("skipped", "Migration #{filename}.rb already exists")
        else
          migration_template "migrations/#{filename}.rb", "db/migrate/#{filename}.rb"
        end
      end
    end
  end
end
