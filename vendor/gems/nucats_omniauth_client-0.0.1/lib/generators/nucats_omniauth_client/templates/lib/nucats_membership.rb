# -*- encoding: utf-8 -*-x
require 'omniauth-oauth2'

class NucatsMembership < OmniAuth::Strategies::OAuth2

  CUSTOM_PROVIDER_URL     = 'http://membership.nubic.northwestern.edu'
  CUSTOM_AUTHORIZE_URL    = "#{CUSTOM_PROVIDER_URL}/auth/nucats_membership/authorize"
  CUSTOM_ACCESS_TOKEN_URL = "#{CUSTOM_PROVIDER_URL}/auth/nucats_membership/access_token"

  option :client_options, {
    :site =>  CUSTOM_PROVIDER_URL,
    :authorize_url => CUSTOM_AUTHORIZE_URL,
    :access_token_url => CUSTOM_ACCESS_TOKEN_URL
  }

  uid { raw_info['id'] }

  info do
    {
      :email => raw_info['email']
    }
  end

  extra do
    {
      :first_name => raw_info['extra']['first_name'],
      :last_name  => raw_info['extra']['last_name']
    }
  end

  def raw_info
    @raw_info ||= access_token.get("/auth/nucats_membership/user.json?oauth_token=#{access_token.token}").parsed
  end
end
