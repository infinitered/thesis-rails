module Thesis
  class RouteConstraint
    def matches?(request)
      slug = request.path.to_s.sub(/(\/)+$/,'')
      return false if excluded_path?(slug)
      Page.where(slug: slug).size > 0
    end

    def excluded_path?(path)
      excluded_extensions = [ :jpg, :jpeg, :png, :css, :js, :ico, :pdf ]
      excluded_extensions.any?{ |ext| path.ends_with?(".#{ext}") }
    end
  end
end
