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
    config.middleware.use Rack::JSONRequests
    config.middleware.use Rack::ApexRedirect
    config.middleware.use Rack::DomainRedirect
    config.middleware.use Rack::CleanPath
    config.middleware.use Rack::PicTwitterRedirect
    config.middleware.use Rack::Teapot
    config.middleware.use Rack::Redirect
    config.middleware.use Rack::Attack
    config.middleware.use Rack::Locale
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    config.active_storage.variant_processor = :vips

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib ignore: %w[assets generators tasks]

    # Set default locale to English
    config.i18n.default_locale = :en

    # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
    # the I18n.default_locale when a translation cannot be found).
    config.i18n.fallbacks = [I18n.default_locale]

    # Allowed list locales available for the application
    config.subdomain_locales = %i[
      ar
      be bg bn
      ca cs cz ceb
      da de dv
      en es eu
      fa fi fo fr
      gl gr
      he hu
      id in it
      ja
      ko ku
      li lt
      ms mt
      nl no
      pl pt
      ro ru
      sh sk sl sv
      th tl tr
      uk
      vi
      zh
    ]

    # Regional locales that have a hyphen in their IANA identifier
    config.subdomain_locales << :'es-419' # Spanish (Latin America)
    config.subdomain_locales << :'fr-qu'  # French  (Canadian/Quebecois)

    path_ltr_locales = %i[
      srpskohrvatski
      malay
      turkce
      english
      espanol
      espanol-america-latina
      lietuvos
      portugues
      quebecois
      日本語
      ภาษาไทย
      한국어
    ]
    path_rtl_locales = %i[فارسی]

    config.i18n.available_locales = [config.subdomain_locales, path_ltr_locales, path_rtl_locales].flatten.sort

    # TODO: rails8
    # TODO: set to false (or delete?) after i18n.load_path is solved below
    config.add_autoload_paths_to_load_path = true
    # TODO: rethink how to allow nested locales directories without load_path
    # Allow nested diretories in locales
    config.i18n.load_path += Rails.root.glob('config/locales/**/*.{rb,yml}')

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # TODO: rails81
    # DEPRECATION WARNING:
    # `to_time` will always preserve the full timezone rather than offset of the receiver in Rails 8.1.
    # is deprecated and will be removed in Rails 8.2
    # To opt in to the new behavior, set `config.active_support.to_time_preserves_timezone = :zone`.
    config.active_support.to_time_preserves_timezone = :zone
  end
end
