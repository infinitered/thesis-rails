module Thesis
  class PageContent < ActiveRecord::Base
    self.table_name = "page_contents"

    belongs_to :page
  end
end