NucatsAssist::Application.configure do
  config.cache_classes = false
  config.action_controller.perform_caching = false
  config.whiny_nils = true

  config.consider_all_requests_local = true
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin

  config.assets.compress = false
  config.assets.debug = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: 'localhost',
      port: 1025
  }
  config.send_notification_to_all = false

  config.aker do
    login_config = File.join(Rails.root, %w(config logins development.yml))
    authority Aker::Authorities::Static.from_file(login_config)
    puts 'loading local static aker file'
    central '/etc/nubic/aker-local.yml'
  end

  OmniAuthConfigure.configure {
    app :nucats_assist
    strategies :nucats_accounts
    central '/etc/nubic/omniauth/local.yml'
  }
end

Paperclip.options[:command_path] = '/opt/local/bin/'
