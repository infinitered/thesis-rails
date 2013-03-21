module Thesis
  module ControllerHelpers
    module ClassMethods
      def class_method_here
        # Sample
      end
    end
    
    def self.included(base)
      raise ActiveRecordRequired.new("Currently, Thesis only works with ActiveRecord.") unless defined? ActiveRecord

      base.extend ClassMethods
      base.helper_method :class_method_here
    end

    def current_page
      # Return current page
    end

    def root_pages
      # Return all root pages
    end

    def page_is_editable?(page)
      raise RequiredMethodNotImplemented.new("Add a `page_is_editable?(page)` method to your controller that returns true or false.")
    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Thesis::ControllerHelpers
  end
end