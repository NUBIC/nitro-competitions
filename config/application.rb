# -*- coding: utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module NucatsAssist
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]

    config.assets.enabled = true
    config.assets.version = '1.0'

    config.active_record.schema_format = :sql

    config.use_omniauth = true

    config.from_address = 'competitions@northwestern.edu'
    config.testing_to_address = 'competitions@northwestern.edu'

    config.middleware.use ExceptionNotification::Rack,
                          email: {
                            email_prefix: "[#{Rails.env}] NITROCompetitions ",
                            sender_address: "competitions@northwestern.edu",
                            exception_recipients: %w{p-friedman@northwestern.edu jeff.lunt@northwestern.edu}
                          }
  end
end
