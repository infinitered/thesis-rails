module Thesis
  class RouteConstraint
    def self.matches?(request)
      slug = request.path.to_s.sub(/(\/)+$/,'')
      return false if excluded_path?(slug)
      Page.where(slug: slug).select("id").first.present?
    end

    def self.excluded_path?(path)
      excluded_extensions = [ :jpg, :jpeg, :png, :css, :js, :ico, :pdf ]
      excluded_extensions.any?{ |ext| path.ends_with?(".#{ext}") }
    end
  end
end
