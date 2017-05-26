# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "staging.pool-madness.com"
    resource "*",
             headers: :any,
             methods: %i[post]
  end
end
