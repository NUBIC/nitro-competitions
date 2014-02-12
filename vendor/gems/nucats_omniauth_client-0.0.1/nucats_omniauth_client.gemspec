# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nucats_omniauth_client/version"

Gem::Specification.new do |s|
  s.name = %q{nucats_omniauth_client}
  s.version = NucatsOmniauthClient::VERSION

  s.authors = ['Paul Friedman']
  s.email = %q{p-friedman@northwestern.edu}
  s.post_install_message = %q{Thanks for installing the NucatsOmniauthClient! Please run the NucatsOmniauthClient generator.}
  s.summary = %q{A gem to enable omniauth authentication in your application through the NUCATS Omniauth Provider}

  s.files = `git ls-files`.split("\n")
end

