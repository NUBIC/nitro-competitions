NucatsAssist::Application.configure do
  config.cache_classes = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.eager_load = false

  config.serve_static_files = false
  config.assets.compress = true
  config.assets.compile = true
  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  config.send_notification_to_all = true

  config.log_level = :debug
end
