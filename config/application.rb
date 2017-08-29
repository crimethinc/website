require_relative "boot"

require "rails/all"
require_relative "../app/middlewares/rack/redirect"
require_relative "../app/middlewares/rack/apex_redirect"
require_relative "../app/middlewares/rack/blog_redirect"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Magazine
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1

    config.middleware.use Rack::Redirect
    config.middleware.use Rack::ApexRedirect
    config.middleware.use Rack::BlogRedirect
    config.middleware.use Rack::Attack
  end
end
