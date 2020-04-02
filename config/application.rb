require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Folio
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = 'Seoul'

    config.autoload_paths += [
        Rails.root.join('lib'),
        Rails.root.join('app', 'services')
    ]

    config.before_configuration do
      config_for(:env).each { |key, value| ENV[key.to_s] = value.to_s }
    end
  end
end
