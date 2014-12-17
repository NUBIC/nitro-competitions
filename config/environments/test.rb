NucatsAssist::Application.configure do
  config.cache_classes = true
  config.serve_static_assets = true
  config.static_cache_control = 'public, max-age=3600'
  config.assets.allow_debugging = true
  config.whiny_nils = true

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false

  config.action_mailer.delivery_method = :test
  config.send_notification_to_all = false
  config.active_support.deprecation = :stderr

  I18n.enforce_available_locales = false
  config.aker do
    login_config = File.join(Rails.root, %w(config logins development.yml))
    authority Aker::Authorities::Static.from_file(login_config)
  end

  config.use_omniauth = false
  OmniAuthConfigure.configure {
    app :nucats_assist
    strategies :nucats_accounts
    central '/etc/nubic/omniauth/local.yml'
  }
end
