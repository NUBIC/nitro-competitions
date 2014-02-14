# -*- encoding: utf-8 -*-x
require 'omniauth-oauth2'

##
# OmniAuth class for the Nucats Membership Application as
# an authorization provider.
class NucatsMembership < OmniAuth::Strategies::OAuth2

  CUSTOM_PROVIDER_URL     = Rails.application.config.oauth_provider_url
  CUSTOM_AUTHORIZE_URL    = "#{CUSTOM_PROVIDER_URL}/auth/nucats_membership/authorize"
  CUSTOM_ACCESS_TOKEN_URL = "#{CUSTOM_PROVIDER_URL}/auth/nucats_membership/access_token"
  # CUSTOM_TOKEN_URL        = "#{CUSTOM_PROVIDER_URL}/oauth/token"

  # token_url: CUSTOM_TOKEN_URL,
  # ssl: { ca_file: '/etc/pki/tls/certs/ca_bundle.crt' }
  # or
  # ssl: { ca_path: '/etc/pki/tls/certs/' }
  option :client_options, {
    site:  CUSTOM_PROVIDER_URL,
    authorize_url: CUSTOM_AUTHORIZE_URL,
    access_token_url: CUSTOM_ACCESS_TOKEN_URL,
    ssl: { ca_path: '/etc/pki/tls/certs/' }
  }

  uid { raw_info['id'] }

  info do
    {
      name: raw_info['info']['name'],
      email: raw_info['info']['email'],
      first_name: raw_info['info']['first_name'],
      last_name: raw_info['info']['last_name']
    }
  end

  extra do
    {
      raw_info: raw_info['extra']['raw_info']
    }
  end



  def raw_info
    @raw_info ||= access_token.get("/auth/nucats_membership/user.json?oauth_token=#{access_token.token}").parsed
  end
end
