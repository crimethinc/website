Bugsnag.configure do |config|
  config.api_key = '52ca1da5064c3aa7d8bdf7cf4f35f2c3'
  config.notify_release_stages = %w[staging production]

  # we consider both staging and production as 'production' for heroku
  # reasons, so set based on ENV variables
  if Rails.env.production?
    staging = ENV['ON_STAGING'] == 'TRUE'
    config.release_stage = staging ? 'staging' : 'production'
  else
    # otherwise it is 'test' or 'development'
    config.release_stage = Rails.env
  end
end
