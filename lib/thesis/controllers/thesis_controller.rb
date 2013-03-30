module Thesis
  class ThesisController < ::ApplicationController
    include Thesis::ControllerHelpers

    def show
      raise ActionController::RoutingError.new('Not Found') unless current_page
      
      if current_page.template && template_exists?("page_templates/#{current_page.template}")
        render "page_templates/#{current_page.template}", layout: false
      else
        raise PageRequiresTemplate.new("Page requires a template but none was specified.")
      end
    end
    
    def create_page      
      page = Page.new
      return head :forbidden unless page_is_editable?(page)

      update_page_attributes page
      if params[:parent_slug].present?
        parent_slug = params[:parent_slug].to_s.sub(/(\/)+$/,'')
        parent = Page.where(slug: parent_slug).first
        page.parent = parent
      end

      resp = {}

      if page.save
        resp[:page] = page
      else
        resp[:message] = page.errors.messages.first
      end

      render json: resp, status: page.valid? ? :ok : :not_acceptable
    end
    
    def delete_page      
      slug = params[:slug].to_s.sub(/(\/)+$/,'')
      page = Page.where(slug: slug).first
      return head :forbidden unless page && page_is_editable?(page)

      head page.destroy ? :ok : :not_acceptable
    end
    
    def update_page
      page = current_page
      return head :forbidden unless page_is_editable?(page)

      update_page_attributes page
      
      head page.save ? :ok : :not_acceptable
    end

    def page_attributes
      [ :name, :title, :description, :parent_id ]
    end
    
    def update_page_attributes(page)
      page_attributes.each { |a| page.send("#{a}=", params[a]) if params[a] }
      page
    end

    def update_page_content
      errors = false
      error_message = "Unknown error."

      page_contents = PageContent.where(id: params.keys).includes(:page).all
      if page_contents.length.zero?
        error_message = "That page doesn't exist anymore."
        errors = true
      else
        page_contents.each do |pc|
          if page_is_editable? pc.page
            pc.content = params[pc.id.to_s]
            pc.save
          else
            errors = true
            error_message = "You don't have permission to update this page."
          end
        end
      end

      resp = {}
      resp[:message] = error_message if errors

      render json: resp, status: errors ? :not_acceptable : :ok
    end
    
    # The ApplicationController should implement this.
    def page_is_editable?(page)
      raise RequiredMethodNotImplemented.new("Add a `page_is_editable?(page)` method to your controller that returns true or false.") unless defined?(super)
      super
    end
  end
end
