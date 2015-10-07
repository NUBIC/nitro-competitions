NucatsAssist::Application.configure do
  config.cache_classes = false
  config.action_controller.perform_caching = false
  config.whiny_nils = true

  config.consider_all_requests_local = true
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin

  config.assets.compress = false
  config.assets.debug = true

  config.app_domain = 'example.com'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: config.app_domain }
  config.action_mailer.smtp_settings = {
      address: 'localhost',
      port: 1025
  }
  config.send_notification_to_all = false

  config.log_level = :debug
end

Paperclip.options[:command_path] = '/opt/local/bin/'
