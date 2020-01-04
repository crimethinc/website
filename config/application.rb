require_relative 'boot'

require 'rails/all'
require_relative '../app/middlewares/rack/json_requests'
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
    config.middleware.use Rack::JsonRequests
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
    config.load_defaults 6.0

    # By default `form_with` generates remote forms. We don't really
    # use this right now, so it is easier to have it default to `false`.
    config.action_view.form_with_generates_remote_forms = false

    # Set default locale to English
    config.i18n.default_locale = :en

    # Whitelist locales available for the application
    subdomain_locales = %i[cz de en es fr pt]
    path_ltr_locales  = %i[
      english
      espanol
      espanol-america-latina
      lietuvos
      portugues
      quebecois
      日本語
      한국어
    ]
    path_rtl_locales = %i[فارسی]
    config.i18n.available_locales = [subdomain_locales, path_ltr_locales, path_rtl_locales].flatten

    # Allow nested diretories in locales
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
