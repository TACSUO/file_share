# Be sure to restart your server when you modify this file.

if defined?(FileShare::Application)
  FileShare::Application.config.session_store :cookie_store, :key => '_file-share_session'
end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# FileShare::Application.config.session_store :active_record_store
