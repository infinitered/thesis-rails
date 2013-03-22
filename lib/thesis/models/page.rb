module Thesis
  class Page < ActiveRecord::Base
    belongs_to :parent, class_name: "Page"
    has_many :subpages, class_name: "Page", foreign_key: "parent_id", order: "sort_order ASC"

    before_save :update_slug
    
    validates :slug, unique: { message: "There's already a page like that. Change your title." }, presence: true
    
    def update_slug
      self.slug = self.title.parameterize
      self.slug = [parent.slug.to_s, self.slug.to_s].join("/") if parent
    end
  end
end