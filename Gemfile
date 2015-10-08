source 'https://rubygems.org'

##
# These two lines are NUCATS specific. 
# Uncomment these lines if you are a part of NUCATS.
# However, if you do end up using omniauth, you will need to
# use one of the several omniauth strategies.
# https://github.com/intridea/omniauth/wiki/List-of-Strategies 
# source 'http://download.bioinformatics.northwestern.edu/gems'
# gem 'omniauth-nucats-accounts'

gem 'devise'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-yahoo'
gem 'omniauth-linkedin'
gem 'omniauth-facebook'
gem 'omniauth-northwestern-medicine', path: 'vendor/gems/omniauth-northwestern-medicine-0.0.2'

gem 'bundler'
gem 'rails', '~> 4.2'

gem 'activerecord-session_store'
gem 'actionpack-action_caching'

gem 'pg'
gem 'haml'
gem 'fastercsv'

gem 'net-ldap'

# ActionView::Template::Error (Could not find a JavaScript runtime.
# See https://github.com/sstephenson/execjs for a list of available runtimes.
gem 'execjs'
gem 'therubyracer'

gem 'rdoc'

gem 'paperclip'

gem 'dotenv-rails'
gem 'faraday'

gem 'lograge'

# Search support gem
# https://github.com/nathanl/searchlight
gem 'searchlight'

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'exception_notification'

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
end
