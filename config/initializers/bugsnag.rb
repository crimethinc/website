Bugsnag.configure do |config|
  config.api_key = Rails.application.config.x.bugsnag.api_key
  config.notify_release_stages = %w[staging production]

  # we consider both staging and production as 'production' for heroku
  # reasons, so set based on ENV variables
  if Rails.env.production?
    staging = Rails.application.config.x.app.on_staging
    config.release_stage = staging ? 'staging' : 'production'
  else
    # otherwise it is 'test' or 'development'
    config.release_stage = Rails.env
  end
end
