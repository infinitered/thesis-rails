module ActionDispatch::Routing
  class Mapper
    def thesis_routes
      # Page crud (AJAX)
      post "thesis/new_page", "thesis/thesis#new_page"

      get "*slug" => 'thesis/thesis#show', constraints: ::Thesis::RouteConstraint
    end
  end
end 