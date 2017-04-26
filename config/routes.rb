PoolMadness::Application.routes.draw do
  if defined?(GraphiQL::Rails::Engine)
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql" => "pages#graphql"
end
