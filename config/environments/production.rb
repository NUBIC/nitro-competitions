NucatsAssist::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_files = false
  config.assets.compress = true
  config.assets.compile = true
  config.assets.digest = true

  config.eager_load = true

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.send_notification_to_all = true

  config.middleware.use ExceptionNotification::Rack,
                        email: {
                          email_prefix: '[Exception] NITRO Competitions ',
                          sender_address: %{'NITRO Competitions Exception Notifier [PRODUCTION]' <p-friedman@northwestern.edu>},
                          exception_recipients: %w{p-friedman@northwestern.edu}
                        }

  config.action_mailer.default_url_options = { host: 'https://grants.nubic.northwestern.edu' }

  config.app_domain = 'northwestern.edu'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: config.app_domain }
  config.action_mailer.smtp_settings = { address: 'smtprelay.northwestern.edu', port: 25, domain: 'northwestern.edu' }

  config.log_level = :info

end
