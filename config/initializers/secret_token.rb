# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
if defined?(FileShare::Application)
  FileShare::Application.config.secret_token = 'bbce55f6968bd726783655882cc294e651853a2deb82d5853867023359e3fca0c01486b0fe9158af6d29fde3dc7347b6029917742f64a66fc2d58712d99565cb'
end
