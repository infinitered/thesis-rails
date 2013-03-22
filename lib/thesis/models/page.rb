module Thesis
  class Page < ActiveRecord::Base
    belongs_to :parent, class_name: "Page"
    has_many :subpages, class_name: "Page", foreign_key: "parent_id", order: "sort_order ASC"


  end
end