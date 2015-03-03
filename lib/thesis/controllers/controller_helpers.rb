module Thesis
  module ControllerHelpers
    def current_page
      @current_page ||= begin
        p = Page.where(slug: current_slug).first_or_initialize
        p.name = current_slug.to_s.split("/").last.to_s.humanize
        p.save!
        p.editable = page_is_editable?(p)
        p
      end
    end

    def current_slug
      request.fullpath.sub(/(\/)+$/,'').presence || "/"
    end

    def root_pages
      @root_pages ||= Page.where(parent_id: nil).order("sort_order ASC")
    end

    def thesis_editor
      current_page.editable ? "<div id='thesis-editor'></div>".html_safe : ""
    end
  end
end
