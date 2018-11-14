require_relative 'boot'

require 'rails/all'
require_relative '../app/middlewares/rack/domain_redirect'
require_relative '../app/middlewares/rack/apex_redirect'
require_relative '../app/middlewares/rack/blog_redirect'
require_relative '../app/middlewares/rack/pic_twitter_redirect'
require_relative '../app/middlewares/rack/redirect'
require 'rack/contrib'

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
    config.middleware.use Rack::Locale
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater

    # Set default locale to English
    config.i18n.default_locale = :en

    # Whitelist locales available for the application
    config.i18n.available_locales = %i[espanol-america-latina en es lietuvos 한국어 english espanol فارسی]

    # Allow nested diretories in locales
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
