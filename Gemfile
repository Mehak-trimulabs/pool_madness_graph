source "https://rubygems.org"

ruby "2.4.1"

gem "active_attr", github: "haruska/active_attr"
gem "binary_decision_tree"
gem "cancancan"
gem "dalli"
gem "email_validator"
gem "espn_scraper", github: "haruska/espn-scraper"
gem "graphql"
gem "knock"
gem "optics-agent"
gem "pg"
gem "rack-cors"
gem "rails", "~> 5.1.0"
gem "redis"
gem "sidekiq"
gem "stripe"

group :staging, :development, :test do
  gem "database_cleaner", github: "DatabaseCleaner/database_cleaner"
  gem "factory_girl_rails"
  gem "faker"
end

group :development, :test do
  gem "dotenv-rails"
  gem "graphiql-rails"
  gem "rspec-rails"
  gem "rubocop"
end

group :production, :staging do
  gem "airbrake"
  gem "newrelic_rpm"
  gem "puma"
  gem "rails_12factor"
end

group :test do
  gem "fuubar"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "stripe-ruby-mock", "~> 2.3.0", require: "stripe_mock"
  gem "webmock"
end
