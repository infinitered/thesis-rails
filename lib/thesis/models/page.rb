module Thesis
  class Page < ActiveRecord::Base
    attr_accessor :editable

    self.table_name = "pages"

    belongs_to :parent, class_name: "Page"
    has_many :subpages, -> { order(:sort_order) }, class_name: "Page", foreign_key: "parent_id"
    has_many :page_contents, dependent: :destroy

    after_save :update_subpage_slugs

    validates :slug,
      uniqueness: { message: "There's already a page at that location." },
      presence: true,
      allow_blank: false,
      allow_null: false

    def update_slug
      self.slug = "/" << self.name.to_s.parameterize
      self.slug = "#{parent.slug.to_s}#{self.slug.to_s}" if parent
    end

    def update_subpage_slugs
      subpages.each(&:save) if slug_changed?
    end

    def content(name, content_type = :html, opts = {})
      find_or_create_page_content(name, content_type, opts).render(editable: self.editable)
    end

    def path
      self.slug
    end

  protected

    def find_or_create_page_content(name, content_type, opts = {})
      page_content =  self.page_contents.where(name: name).first_or_create do |pc|
        pc.content =  opts[:default]  || "<p>Edit This HTML Area</p>" if content_type == :html
        pc.content =  opts[:default]  || "Edit This Text Area" if content_type == :text
        width =       opts[:width]    || 350
        height =      opts[:height]   || 150
        pc.content =  opts[:default]  || "http://placehold.it/#{width}x#{height}" if content_type == :image
      end
      page_content.content_type = content_type
      page_content.save if page_content.changed?
      page_content
    end
  end
end
