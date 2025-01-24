# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rails'
require 'webmock/rspec'
require 'sidekiq/testing'
require 'pry'
require 'money-rails/test_helpers'

# silence logs when running specs: https://github.com/rspec/rspec-rails/issues/1897
Capybara.server = :puma, { Silent: true }
Capybara.register_driver :chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    capabilities: [options]
  )
end

# Setting up WEBDRIVER gem with browser version apis  for webmock and VCR:
# https://github.com/titusfortner/webdrivers/wiki/Using-with-VCR-or-WebMock

require 'uri'
driver_hosts = Webdrivers::Common.subclasses.map { |driver| URI(driver.base_url).host }
driver_urls = Webdrivers::Common.subclasses.map(&:base_url)

# add below when you hook into webmock
WebMock.disable_net_connect!(allow_localhost: true, allow: driver_urls)

VCR.configure do |config|
  config.hook_into :webmock
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.configure_rspec_metadata!
  # config.filter_sensitive_data('<api_key>') { ENV['STRIPE_SECRET_KEY'] }
  config.allow_http_connections_when_no_cassette = false
  config.ignore_hosts('localhost', '127.0.0.1', '0.0.0.0', 'googlechromelabs.github.io', 'storage.googleapis.com',
                      *driver_hosts)
  config.debug_logger = File.open(Rails.root.join('log', 'vcr.log'), 'w')
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.example_status_persistence_file_path = "#{::Rails.root}/spec/examples.txt"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.before(:each, type: :system) do
    driven_by :chrome_headless
    # page.driver.browser.url_whitelist = ['127.0.0.1']
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/test_files/"])
  end

  # adding devise helpers to controller tests
  config.include FeatureHelpers, type: :system
  config.include RequestHelpers, type: :request
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
