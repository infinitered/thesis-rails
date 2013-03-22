require "thesis/version"
require "thesis/exceptions"
require "thesis/base"
require "thesis/controller_helpers" # Included into ActionController::Base
require "thesis/thesis_controller"
require "thesis/route_constraint"
require "thesis/routes"

# Models
require "thesis/models/page"
require "thesis/models/page_content"

module Thesis
  require 'thesis/railtie' if defined?(Rails)
end
