require ::File.expand_path('../../config/environment',  __FILE__)
Rails.application.eager_load!

require 'action_cable/process/logging'

# This is necessary due to new security policies 
# Be carefull !!! This is not documented in the actioncable examples
# in the official repo from DHH
ActionCable.server.config.allowed_request_origins = ["http://localhost:3000"]

run ActionCable.server
