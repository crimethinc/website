SIDEKIQ_REDIS_CONFIGURATION = {
  # use REDIS_PROVIDER for Redis environment variable name, defaulting to REDIS_URL
  url:        Rails.application.config.x.redis.url,
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
}.freeze

Sidekiq.configure_server do |config|
  config.redis = SIDEKIQ_REDIS_CONFIGURATION
end

Sidekiq.configure_client do |config|
  config.redis = SIDEKIQ_REDIS_CONFIGURATION
end
