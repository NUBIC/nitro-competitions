require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups(assets: %w(development test)))

module NucatsAssist
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # TO DO: review lib directory
    # As of 5.2 upgrade, default is app/* and "it is no longer recommended to adjust"
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    # Removed in upgrade to 5.2, default is utf-8
    # config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    # Removed in upgrade to 5.2, filtered in config/initializers/filter_parameter_logging.
    # config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    # Removed in upgrade to 5.2, defaults to true
    # config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Use Routes Engine as exceptions_app
    config.exceptions_app = routes

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true
    # Suggested fix in http://railscasts.com/episodes/415-upgrading-to-rails-4?view=asciicast
    # for issues with mass assignment error.
    # config.active_record.whitelist_attributes = false

    # Removed in upgrade to 5.2, default is true
    # Enable the asset pipeline
    # config.assets.enabled = true

    # Removed in upgrade to 5.2, set in config/initializers/assets.rb
    # Version of your assets, change this if you want to expire all your assets
    # config.assets.version = '1.0'


    # The line below was removed when updating to Rails 5.1.5
    # config.active_record.raise_in_transactional_callbacks = true

    config.action_controller.forgery_protection_origin_check = true
    # config.action_mailer.perform_caching = true
    ActiveSupport.to_time_preserves_timezone = true

    # Removed in upgrade to 5.2. HAML files removed.
    # # Generate HAML templates
    # config.generators do |g|
    #   g.template_engine :haml
    #   g.test_framework :rspec
    # end

    config.active_record.schema_format = :sql
    config.use_nu = true
    config.from_address = 'nitro-noreply@northwestern.edu'
    config.testing_to_address = 'competitions@northwestern.edu'
    config.middleware.use ExceptionNotification::Rack,
                          email: {
                            email_prefix: "[#{Rails.env}] NITROCompetitions ",
                            sender_address: "nitro-noreply@northwestern.edu",
                            exception_recipients: %w{competitions@northwestern.edu}
                          }
    config.nucats_assist_config = ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file(YAML.load_file(File.join(Rails.root, 'config', 'nucats_assist_config.yml'))))

    # Added in upgrade to 5.2
    config.active_record.belongs_to_required_by_default = false
  end
end
