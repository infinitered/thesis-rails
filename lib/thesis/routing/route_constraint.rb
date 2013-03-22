module Thesis
  class RouteConstraint
    def self.matches?(request)
      Page.where(slug: request.path.to_s).select("id").first.present?
    end
  end
end
