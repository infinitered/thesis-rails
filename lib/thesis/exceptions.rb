module Thesis
  # A generic Thesis exception
  class Error < StandardError; end

  # When a required method is not implemented 
  class RequiredMethodNotImplemented < StandardError; end

  # ActiveRecord is the only ORM that works with this currently
  class ActiveRecordRequired < StandardError; end
end
