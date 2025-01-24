# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TechnicalExercise
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.paths << Rails.root.join('app', 'assets', 'public_files')

    # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
    config.force_ssl = true

    # Expire in a hour vs 1 year (the default)
    config.ssl_options = { hsts: { expires: 3600 } }

    config.active_job.queue_adapter = :sidekiq
    config.add_autoload_paths_to_load_path = false

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += %i[password card_number card_cvc]

    config.generators do |g|
      g.template_engine :slim
      g.test_framework :rspec, fixture: false, view_specs: false
      g.fixture_replacement :factory_bot
      g.stylesheets false
    end

    config.load_google_tags = false

    config.load_tapfiliate = false
    config.load_capterra = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
