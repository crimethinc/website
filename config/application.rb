require_relative 'boot'

require 'rails/all'
require_relative '../app/middlewares/rack/domain_redirect'
require_relative '../app/middlewares/rack/apex_redirect'
require_relative '../app/middlewares/rack/blog_redirect'
require_relative '../app/middlewares/rack/redirect'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Crimethinc
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1

    config.middleware.use Rack::DomainRedirect
    config.middleware.use Rack::ApexRedirect
    config.middleware.use Rack::BlogRedirect
    config.middleware.use Rack::PicTwitterRedirect
    config.middleware.use Rack::Redirect
    config.middleware.use Rack::Attack
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater

    # allow nested diretories in locales
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :en
  end
end
