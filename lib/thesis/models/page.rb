module Thesis
  class Page < ActiveRecord::Base
    self.table_name = "pages"
    
    belongs_to :parent, class_name: "Page"
    has_many :subpages, class_name: "Page", foreign_key: "parent_id", order: "sort_order ASC"

    before_validation :update_slug
    after_save :update_subpage_slugs
    
    validates :slug, uniqueness: { message: "There's already a page like that. Change your page name." }, presence: true
    
    def update_slug
      @previous_slug = self.slug
      self.slug = "/" << self.name.parameterize
      self.slug = "#{parent.slug.to_s}#{self.slug.to_s}" if parent
    end
    
    def update_subpage_slugs
      subpages.each(&:save) if @previous_slug != self.slug
    end
  end
end