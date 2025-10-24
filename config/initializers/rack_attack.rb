if Rails.env.production?
  module Rack
    class Attack
      throttle('limit requests per IP', limit: 60, period: 1.minute) do |req|
        # Allow trusted requests through unthrottled
        trusted_request =
          ENV.fetch('RACK_ATTACK_ALLOWED_USER_AGENT', nil).present? &&
          req.user_agent&.starts_with?(ENV.fetch('RACK_ATTACK_ALLOWED_USER_AGENT'))

        # Allow Asset Pipeline and ActiveStorage requests through unthrottled
        asset_pipeline = req.path.start_with? '/assets'
        active_storage = req.path.start_with? '/rails/active_storage'

        req.ip unless trusted_request || asset_pipeline || active_storage
      end
    end
  end
end
