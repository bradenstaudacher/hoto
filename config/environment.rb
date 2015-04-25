# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Hoto::Application.initialize! do |config|

    config.load_paths << "#{RAILS_ROOT}/app/models/actions"
end

# require 'pusher'

# Pusher.app_id = '116720'
# Pusher.key = 'e6e3668b059767b856df'
# Pusher.secret = '931ecb9ac730c358e6d9'

