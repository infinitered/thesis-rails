module Thesis
  class PageContent < ActiveRecord::Base
    self.table_name = "page_contents"

    belongs_to :page
    validates :page_id, presence: true

    def render
      case self.content_type.to_sym
      when :html
        render_html
      when :text
        render_plain_text
      when :image
        render_image
      else
        render_html
      end
    end

    protected

    def render_html
      (
        "<thesis-content class='thesis-content thesis-content-html' data-thesis-content-id='#{self.id}'>" +
          "#{self.content}" +
        "</thesis-content>"
      ).html_safe
    end

    def render_plain_text
      (
        "<thesis-content class='thesis-content thesis-content-text' data-thesis-content-id='#{self.id}'>" +
          "#{self.content}" +
        "</thesis-content>"
      ).html_safe
    end

    def render_image
      (
        "<thesis-content class='thesis-content thesis-content-image'>" +
          "<img src='#{self.content}' />" +
        "</thesis-content>"
      ).html_safe
    end
  end
end
