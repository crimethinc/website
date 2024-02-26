require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Format webserver logs in Logstash formatted JSON using Lograge
  config.lograge.enabled   = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new

  # Code is not reloaded between requests.
  config.enable_reloading = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Configure memcache as the cache_store if available
  # Pulled from https://devcenter.heroku.com/articles/memcachedcloud
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

  # Ensures that a master key has been made available in either ENV['RAILS_MASTER_KEY']
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from `public/`, relying on NGINX/Apache to do so instead.
  config.public_file_server.enabled = ENV.fetch('RAILS_SERVE_STATIC_FILES') { nil }.present?

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files in AWS S3 (see config/storage.yml for options).
  config.active_storage.service = :production

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # Can be used together with config.force_ssl for Strict-Transport-Security and secure cookies.
  # config.assume_ssl = true

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Mailer sending for /support, using SendGrid
  config.action_mailer.delivery_method    = :smtp
  config.action_mailer.perform_caching    = false
  config.action_mailer.perform_deliveries = true

  # Background jobs
  # Use a real queuing backend for Active Job (and separate queues per environment).
  config.active_job.queue_adapter     = :sidekiq
  config.active_job.queue_name_prefix = 'crimethinc_production'

  # TODO: Extract to ENV var in .env and staging/production environments
  # For using #url_for et al in non-views/helpers
  Rails.application.routes.default_url_options[:host] =
    if ENV.fetch('ON_STAGING') { 'FALSE' } == 'TRUE'
      'crimethincstaging.com'
    else
      'crimethinc.com'
    end

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = [I18n.default_locale]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV.fetch('RAILS_LOG_TO_STDOUT') { nil }.present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
