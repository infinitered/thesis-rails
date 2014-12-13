module Thesis
  module ControllerHelpers
    def current_page
      @current_page ||= Page.where(slug: current_slug).first_or_create
    end

    def current_slug
      request.fullpath.sub(/(\/)+$/,'').presence || "/"
    end

    def root_pages
      @root_pages ||= Page.where(parent_id: nil).order("sort_order ASC")
    end

    def thesis_editor
      "<div id='thesis-editor'></div>".html_safe if page_is_editable?(current_page)
    end
  end
end
