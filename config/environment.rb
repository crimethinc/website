# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# TODO: this line is needed for rails console to work, but isn't
# needed when running rails server....why?
require 'carrierwave/orm/activerecord'
