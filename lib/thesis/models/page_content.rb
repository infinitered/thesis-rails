module Thesis
  class PageContent < ActiveRecord::Base
    self.table_name = "page_contents"

    belongs_to :page
    
    def render
      case self.content_type
      when :html
        render_html
      when :text
        render_text
      else
        render_html
      end
    end
    
    protected
    
    def render_html
      h = "<div class='thesis-content thesis-content-html' data-thesis-content-id='#{self.id}'>" +
      "#{self.content}" + 
      "</div>"
      h.html_safe
    end
    
    def render_text
      h = "<span class='thesis-content thesis-content-text' data-thesis-content-id='#{self.id}'>" +
      "#{self.content}" +
      "</span>"
      h.html_safe
    end
    
    def render_image
      h = "<div class='thesis-content thesis-content-image'>" +
      "<img src='#{self.content}' />" +
      "</div>"
      h.html_safe
    end
  end
end