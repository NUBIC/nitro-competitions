## NUCATS Omniauth Client

Using this gem makes it easy for an application to use the
['NUCATS Membership application'][nucats_membership] as an ['omniauth'][omniauth]
provider. (Actually a proxy provider as the NUCATS Membership application simply
defers authentication to Northwestern or other external authentication providers.)

All that needs to happen is to install the gem in your application, register your
application as a ['client'][client] under your NUCATS membership account, and
enter the APP_ID and APP_SECRET values in the
#{Rails.root}/config/initializers/omniauth.rb file which was created upon install.

And yes, you need to be a NUCATS member in order to register your client application.

Of course you'll need to integrate ['omniauth'][omniauth] into your application.
This gem simply helps you setup this integration by configuring the
['NUCATS Membership application'][nucats_membership] as one of your
['omniauth'][omniauth] providers.

[nucats_membership]: http://membership.nubic.northwestern.edu
[omniauth]: https://github.com/intridea/omniauth
[client]: http://membership.nubic.northwestern.edu/clients

## Requirements

Nucats Omniauth Client works with:

* Ruby 1.9.2 and 1.9.3
* Rails 3.1-4.0

Some key dependencies are:

* gem 'omniauth'
* gem 'omniauth-oauth2'

## Install

Add nucats_omniauth_client to your Gemfile:

    source 'http://download.bioinformatics.northwestern.edu/gems'
    gem 'nucats_omniauth_client'

Bundle and install:

    bundle install
    script/rails generate nucats_omniauth_client:install
