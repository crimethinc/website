require_relative 'boot'

require 'rails/all'
require_relative '../app/middlewares/rack/domain_redirect'
require_relative '../app/middlewares/rack/apex_redirect'
require_relative '../app/middlewares/rack/clean_path'
require_relative '../app/middlewares/rack/pic_twitter_redirect'
require_relative '../app/middlewares/rack/redirect'
require_relative '../app/middlewares/rack/teapot'
require 'rack/contrib'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Crimethinc
  class Application < Rails::Application
    config.middleware.use Rack::DomainRedirect
    config.middleware.use Rack::ApexRedirect
    config.middleware.use Rack::CleanPath
    config.middleware.use Rack::PicTwitterRedirect
    config.middleware.use Rack::Teapot
    config.middleware.use Rack::Redirect
    config.middleware.use Rack::Attack
    config.middleware.use Rack::Locale
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Set default locale to English
    config.i18n.default_locale = :en

    # Whitelist locales available for the application
    config.i18n.available_locales = %i[日本語 cz de en es fr portugues quebecois espanol-america-latina lietuvos 한국어 english espanol فارسی]

    # Allow nested diretories in locales
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # TEMP: This deprecation warning showed up in Rails 6.rc2.
    #       We're not using #content_type anywhere,
    #       so I expect the need for this will go away on its own in time.
    # DEPRECATION WARNING: Rails 6.1 will return Content-Type header without modification.
    # If you want just the MIME type, please use `#media_type` instead.
    config.action_dispatch.return_only_media_type_on_content_type = false
  end
end
