source "https://rubygems.org"

ruby "2.4.1"

gem "active_attr_extended"
gem "binary_decision_tree"
gem "cancancan"
gem "dalli"
gem "email_validator"
gem "espn_scraper", github: "haruska/espn-scraper"
gem "graphql"
gem "httparty"
gem "knock"
gem "optics-agent"
gem "pg"
gem "rack-cors"
gem "rails", "~> 5.1.0.rc2"
gem "redis"
gem "sidekiq"
gem "stripe"

group :staging, :development, :test do
  gem "database_cleaner", github: "DatabaseCleaner/database_cleaner"
  gem "factory_girl_rails"
  gem "faker"
end

group :development, :test do
  gem "awesome_print"
  gem "better_errors"
  gem "binding_of_caller"
  gem "byebug"
  gem "capybara"
  gem "capybara-screenshot"
  gem "dotenv-rails"
  gem "graphiql-rails"
  gem "letter_opener"
  gem "letter_opener_web"
  gem "listen"
  gem "magic_lamp"
  gem "pry"
  gem "pry-nav"
  gem "rails-erd"
  gem "rspec-rails"
  gem "rubocop"
  gem "selenium-webdriver"
  gem "spring"
end

group :production, :staging do
  gem "airbrake"
  gem "newrelic_rpm"
  gem "puma"
  gem "rails_12factor"
end

group :production do
  gem "hirefire-resource"
  gem "postmark-rails"
end

group :development do
  gem "bullet"
  gem "lol_dba"
  gem "web-console"
end

group :test do
  gem "fuubar"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "stripe-ruby-mock", "~> 2.3.0", require: "stripe_mock"
  gem "webmock"
end
