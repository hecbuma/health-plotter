require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HealthPlotter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoload_paths << "#{Rails.root}/app/services"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end

  Raven.configure do |config|
    config.dsn = 'https://b9e3c4b17e0f4d56a6071355bf1db735:c64ba21505aa4f4aaa8fea2a695526be@sentry.io/1764305'
  end
end
