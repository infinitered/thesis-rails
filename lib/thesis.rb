require "thesis/version"
require "thesis/exceptions"
require "thesis/base"
require "thesis/controller_helpers" # Included into ActionController::Base
require "thesis/routes"

module Thesis
  require 'thesis/railtie' if defined?(Rails)
end
