module Thesis
  module ControllerHelpers
    module ClassMethods
      def class_method_here
        # Sample
      end
    end
    
    def self.included(base)
      raise ActiveRecordRequired.new("Currently, Thesis only works with ActiveRecord.") unless defined? ActiveRecord

      # base.extend ClassMethods
      # base.helper_method :class_method_here
    end

    def current_page
      @current_page ||= Page.where(slug: request.fullpath).first
    end

    def root_pages
      @root_pages ||= Page.where(parent_id: nil).order("sort_order ASC").all
    end
    
    def thesis_editor
      "<div id='thesis-editor'></div>".html_safe if page_is_editable?(current_page)
    end
  end
end
