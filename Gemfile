source "https://rubygems.org"

ruby "3.0.3"

gem "aws-sdk-s3", require: false
gem "bootsnap", require: false
gem "dartsass-rails", "~> 0.3.0"
gem "forgery"
gem "httparty"
gem "image_processing"
gem "kaminari"
gem "importmap-rails"
gem "lograge"
gem "money-rails", "~>1"
gem "pg"
gem "postmark-rails"
gem "puma", "~> 4.3.5"
gem "rails", "~> 7.0.2.2"
gem "sidekiq", "< 7"
gem "simple_form", "5.0.2"
gem "slim"
gem "sprockets-rails"
gem "stimulus-rails"
gem "strong_migrations"
gem "turbo-rails"
gem "redis", "~> 4.0"

group :development, :test do
  gem "annotate"
  gem "bundle-audit"
  gem "dotenv-rails", "2.7.6" # env variables for dev and test
  gem "factory_bot_rails"
  gem "foreman"
  gem "pry-rails"
  gem "rspec-rails"
  gem "standard"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller" # for REPL with better_errors
  gem "slim-rails" # for slim generator templates
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "vcr"
  gem "webdrivers"
  gem "webmock", require: false
end
