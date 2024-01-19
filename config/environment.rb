# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.config.hosts << "lucias.work"

Rails.application.initialize!

# trying to fix action dispatch error digital ocean
Rails.application.config.hosts.clear
