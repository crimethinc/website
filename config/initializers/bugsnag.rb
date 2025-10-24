Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUGSNAG_API_KEY', nil)
  config.notify_release_stages = %w[staging production]

  # we consider both staging and production as 'production' for heroku
  # reasons, so set based on ENV variables
  if Rails.env.production?
    staging = ENV.fetch('ON_STAGING') { 'FALSE' } == 'TRUE'
    config.release_stage = staging ? 'staging' : 'production'
  else
    # otherwise it is 'test' or 'development'
    config.release_stage = Rails.env
  end
end
