require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IsspayApi
  extend Econfig::Shortcut
  Econfig.root = '.'
  Econfig.env = Rails.env

  class Application < Rails::Application

    config.cache_store = :redis_cache_store, { url: IsspayApi.config.REDIS_URL }
    config.action_controller.perform_caching = true

    config.session_store :cache_store, key: IsspayApi.config.APP_SESSION_KEY

    config.autoload_paths += %W(#{config.root}/app/serializers #{config.root}/app/forms #{config.root}/app/validators)
    config.eager_load_paths += %W(#{config.root}/app/serializers #{config.root}/app/forms #{config.root}/app/validators)
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = false
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
