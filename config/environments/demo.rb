NucatsAssist::Application.configure do
  config.cache_classes = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.compile = true
  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  config.send_notification_to_all = true

  config.aker do
    login_config = File.join(Rails.root, %w(config logins demo.yml))
    authority Aker::Authorities::Static.from_file(login_config)
    puts 'loading local static aker file'
  end

  config.use_omniauth = false
  OmniAuthConfigure.configure {
    app :nucats_assist
    strategies :nucats_accounts
    central '/etc/nubic/omniauth/demo.yml'
  }
end
