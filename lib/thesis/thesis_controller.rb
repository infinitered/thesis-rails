module Thesis
  class ThesisController < ActionController::Base
    include ControllerHelpers
    
    def show
      
    end
    
    def new_page      
      page = Page.new
      return head :forbidden unless page_is_editable?(page)

      update_page_attributes page

      head page.save ? :ok : :not_acceptable
    end
    
    def update_page
      page = current_page
      return head :forbidden unless page_is_editable?(page)

      update_page_attributes page
      
      head page.save ? :ok : :not_acceptable
    end
    
    def update_page_attributes(page)
      page.title = params[:title]
      page.description = params[:description]
      page.parent_id = params[:parent_id]
    end
    
  protected
    
    def page_is_editable?(page)
      appcon = ApplicationController.new
      if appcon.respond_to?(:page_is_editable)
        appcon.page_is_editable?(page)
      else
        raise RequiredMethodNotImplemented.new("Add a `page_is_editable?(page)` method to your controller that returns true or false.")
      end
    end
  end
end