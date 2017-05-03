PoolMadness::Application.routes.draw do
  post "/graphql" => "pages#graphql"
end
