module Thesis
  class PageContent < ActiveRecord::Base
    self.table_name = "page_contents"

    belongs_to :page
    validates :page_id, presence: true

    def render(args={})
      args[:editable] ? render_editable : render_content
    end

    def render_editable
      case self.content_type.to_sym
      when :html then  render_html_editable
      when :text then  render_plain_text_editable
      when :image then render_image_editable
      else render_html_editable
      end
    end

    def render_content
      case self.content_type.to_sym
      when :image then render_image_tag
      else self.content.to_s.html_safe
      end
    end

    protected

    def render_html_editable
      (
        "<thesis-content class='thesis-content thesis-content-html' data-thesis-content-id='#{self.id}'>" +
          "#{self.content}" +
        "</thesis-content>"
      ).html_safe
    end

    def render_plain_text_editable
      (
        "<thesis-content class='thesis-content thesis-content-text' data-thesis-content-id='#{self.id}'>" +
          "#{self.content}" +
        "</thesis-content>"
      ).html_safe
    end

    def render_image_editable
      (
        "<thesis-content class='thesis-content thesis-content-image' data-thesis-content-id='#{self.id}'>" +
          render_image_tag +
        "</thesis-content>"
      ).html_safe
    end

    def render_image_tag
      "<img src='#{self.content}' />".html_safe
    end
  end
end
