# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
#Rails.application.config.hosts << "lucias.work"
Rails.application.config.hosts << "www.websustainabilityguidelines.com"
Rails.application.config.hosts << "websustainabilityguidelines.com"

Rails.application.initialize!

# trying to fix action dispatch error digital ocean (should not make any difference)
# Rails.application.config.hosts.clear
