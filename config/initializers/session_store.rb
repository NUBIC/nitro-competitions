# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_nucats_assist_session2',
  :secret      => '117a882bcdb1a8670420b0a6f71cbd2d564103359b7e21f25ffe93e0ca668260886a1fa95660e5a9665e92846ab6fdcd3a813bd60c282ba7770f36e0e90401df'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
