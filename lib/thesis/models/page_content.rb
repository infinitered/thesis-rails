module Thesis
  class PageContent < ActiveRecord::Base
    belongs_to :page
  end
end