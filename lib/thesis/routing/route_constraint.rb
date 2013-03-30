module Thesis
  class RouteConstraint
    def self.matches?(request)
      slug = request.path.to_s.sub(/(\/)+$/,'')
      Page.where(slug: slug).select("id").first.present?
    end
  end
end
