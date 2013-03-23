module Thesis
  class Engine < ::Rails::Engine
    # isolate_namespace Thesis # We're accessing the application controller, so we can't do this.
  end
end
