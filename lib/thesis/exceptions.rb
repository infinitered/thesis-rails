module Thesis
  # A generic Thesis exception
  class Error < StandardError; end

  # When a required method is not implemented 
  class RequiredMethodNotImplemented < StandardError; end

  # ActiveRecord is the only ORM that works with this currently
  class ActiveRecordRequired < StandardError; end

  # 404s
  # class PageNotFound < ActionController::RoutingError; end

  # No template specified
  class PageRequiresTemplate < StandardError; end

end
