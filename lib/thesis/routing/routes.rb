module ActionDispatch::Routing
 class Mapper
   def thesis_routes
      put "thesis/update_page_content" => "thesis/thesis#update_page_content"
      post "thesis/create_page" => "thesis/thesis#create_page"
      delete "thesis/delete_page" => "thesis/thesis#delete_page"

      get "*slug" => 'thesis/thesis#show', constraints: ::Thesis::RouteConstraint.new
    end
  end
end
