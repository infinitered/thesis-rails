module Thesis
  module ControllerHelpers
    def current_page
      slug = request.fullpath.sub(/(\/)+$/,'')
      @current_page ||= Page.where(slug: slug).first
      @current_page
    end

    def root_pages
      @root_pages ||= Page.where(parent_id: nil).order("sort_order ASC")
    end
    
    def thesis_editor
      "<div id='thesis-editor'></div>".html_safe if page_is_editable?(current_page)
    end
  end
end
