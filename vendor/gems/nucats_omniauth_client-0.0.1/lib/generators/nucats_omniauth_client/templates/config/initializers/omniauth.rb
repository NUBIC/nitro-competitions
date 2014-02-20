# -*- encoding: utf-8 -*-

# Change this omniauth configuration to point to your registered provider,
# Since this is a registered application, add the app id and secret here.
# The APP_ID and APP_SECRET values can be obtained at the nucats
# membership omniauth provider site:
#   https://membership.nubic.northwestern.edu/clients
# Upon creating a new client application you will see the
# app_id and app_secret associated with the regiestered client application.
APP_ID = 'APP_ID'
APP_SECRET = 'APP_SECRET'

CUSTOM_PROVIDER_URL = 'http://membership.nubic.northwestern.edu'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :nucats_membership, APP_ID, APP_SECRET
end
