require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { 'cache-control' => "public, max-age=#{1.year.to_i}" }

  # Enable serving static files from `public/`, Heroku sets RAILS_SERVE_STATIC_FILES to 'enabled'
  config.public_file_server.enabled = ENV.fetch('RAILS_SERVE_STATIC_FILES') { nil }.present?

  # TODO: rails8 delete this after confirming .scss files still work
  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # TODO: rails8 delete this after confirming nothing in app/assets is broken
  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files in AWS S3 (see config/storage.yml for options).
  config.active_storage.service = :production

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # TODO: rails8 extract to an initializer?
  # Format webserver logs in Logstash formatted JSON using Lograge
  config.lograge.enabled   = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [:request_id]
  config.logger   = ActiveSupport::TaggedLogging.logger($stdout)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = '/up'

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Replace the default in-process and non-durable queuing backend for Active Job.
  config.active_job.queue_adapter     = :sidekiq
  config.active_job.queue_name_prefix = 'crimethinc_production'

  # # TODO: rails8 `app:update` suggests removing this line altogether. delete it, after confirming?
  # Disable caching for Action Mailer templates even if Action Controller caching is enabled.
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # # TODO: rails8 this is the suggestion in `app:update`
  # # Set host to be used by links generated in mailer templates.
  # if ENV.fetch('ON_STAGING') { 'FALSE' } == 'TRUE'
  #   config.action_mailer.default_url_options = { host: 'crimethincstaging.com' }
  # else
  #   config.action_mailer.default_url_options = { host: 'crimethinc.com' }
  # end

  # TODO: rails8 Extract to ENV var in .env and staging/production environments
  # For using #url_for et al in non-views/helpers
  Rails.application.routes.default_url_options[:host] =
    if ENV.fetch('ON_STAGING') { 'FALSE' } == 'TRUE'
      'crimethincstaging.com'
    else
      'crimethinc.com'
    end

  # TODO: rails8 extract to an initializer?
  # Mailer sending for /support, using SendGrid
  config.action_mailer.delivery_method    = :smtp
  config.action_mailer.perform_deliveries = true

  # Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain
  # }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = [I18n.default_locale]

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [:id]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  #
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # TODO: rails8 use simpler defaults?
  # Replace the default in-process memory cache store with a durable alternative.
  # config.cache_store = :mem_cache_store

  # TODO: rails8 extract to an initializer?
  # Configure memcache as the cache_store if available
  # Copied from https://devcenter.heroku.com/articles/memcachedcloud
  # Replace the default in-process memory cache store with a durable alternative.
  config.cache_store = if ENV.fetch('MEMCACHEDCLOUD_SERVERS') { nil }
                         [
                           :mem_cache_store,
                           ENV.fetch('MEMCACHEDCLOUD_SERVERS').split(','),
                           {
                             username: ENV.fetch('MEMCACHEDCLOUD_USERNAME'),
                             password: ENV.fetch('MEMCACHEDCLOUD_PASSWORD')
                           }
                         ]
                       else
                         # Cache in memory otherwise
                         [:memory_store, { size: 64.megabytes }]
                       end
end
