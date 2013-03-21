require 'thesis'
require 'rails'

module Thesis
  class Railtie < Rails::Railtie
    railtie_name :thesis

    rake_tasks do
      # load File.join(File.dirname(__FILE__), "tasks/db.rake") # Load rake tasks here
    end
  end
end