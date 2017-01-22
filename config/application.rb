require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Magazine
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.middleware.use "Rack::Redirect"

    config.middleware.use Rack::Attack

    # Monitor database
    NewRelicPing.configure do |c|
      c.monitor("database") do
        ActiveRecord::Base.connection.execute("select count(*) from schema_migrations")
      end
    end

  end
end
