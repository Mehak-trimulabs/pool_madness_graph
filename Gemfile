source "https://rubygems.org"

ruby "2.6.5"

gem "active_attr", github: "haruska/active_attr"
gem "auth0"
gem "binary_decision_tree"
gem "cancancan"
gem "connection_pool"
gem "dalli"
gem "espn_scraper", github: "poolmadness/espn-scraper"
gem "graphql"
gem "knock"
gem "pg"
gem "rack-cors"
gem "rails", "~> 5.2.0"
gem "redis"
gem "sidekiq"
gem "stripe"

group :staging, :development, :test do
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "faker"
end

group :development, :test do
  gem "dotenv-rails"
  gem "rspec-rails"
  gem "rubocop"
  gem "rubocop-faker"
end

group :production, :staging do
  gem "airbrake"
  gem "newrelic_rpm"
  gem "puma"
  gem "rails_12factor"
end

group :development do
  gem "listen"
end

group :test do
  gem "fuubar"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "stripe-ruby-mock", "~> 2.3.0", require: "stripe_mock"
  gem "webmock"
end
