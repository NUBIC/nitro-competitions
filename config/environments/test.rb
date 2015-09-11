NucatsAssist::Application.configure do
  config.cache_classes = true
  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=3600'
  config.assets.allow_debugging = true
  config.whiny_nils = true

  config.eager_load = false

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false

  config.action_mailer.delivery_method = :test
  config.send_notification_to_all = false
  config.active_support.deprecation = :stderr

  I18n.enforce_available_locales = false
end
