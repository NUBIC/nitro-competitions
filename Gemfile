source 'https://rubygems.org'
source 'http://download.bioinformatics.northwestern.edu/gems'

gem 'bundler'
gem 'rails', '3.2.16'
gem 'pg'
gem 'haml'
gem 'will_paginate'
gem 'fastercsv'
gem 'princely'

gem 'net-ldap'
gem 'bcdatabase'

# Authorization
# TODO: remove aker in favor of omniauth
gem 'aker-rails'
gem 'aker'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'nucats_omniauth_client', path: 'vendor/gems/nucats_omniauth_client-0.0.1'

# ActionView::Template::Error (Could not find a JavaScript runtime.
# See https://github.com/sstephenson/execjs for a list of available runtimes.
gem 'execjs'
gem 'therubyracer'

gem 'rdoc'

gem 'paperclip'

# For Rails 3 upgrade - adds helpers removed from Rails 2
gem 'prototype_legacy_helper', '0.0.0', :git => 'git://github.com/rails/prototype_legacy_helper.git'

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'annotate', '~> 2.5.0'
end

gem 'prototype-rails'

group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'simplecov', require: false
end
