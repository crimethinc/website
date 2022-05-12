if Rails.env.production?
  module Rack
    class Attack
      throttle('limit requests per IP', limit: 60, period: 1.minute) do |req|
        # Allow trusted requests through unthrottled
        trusted_request =
          ENV.fetch('RACK_ATTACK_ALLOWED_USER_AGENT') { nil }.present? &&
          req.user_agent&.starts_with?(ENV.fetch('RACK_ATTACK_ALLOWED_USER_AGENT'))

        # Allow Asset Pipeline and ActiveStorage requests through unthrottled
        asset_pipeline = req.path.start_with? '/assets'
        active_storage = req.path.start_with? '/rails/active_storage'

        req.ip unless trusted_request || asset_pipeline || active_storage
      end

      # Lockout IP addresses that are hammering our login page.
      # After 10 requests in 1 minute, block all requests from that IP for 1 hour.
      Rack::Attack.blocklist('allow2ban login scrapers') do |req|
        # `filter` returns false value if request is to your login page (but still
        # increments the count) so request below the limit are not blocked until
        # they hit the limit.  At that point, filter will return true and block.
        Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 10, findtime: 1.minute, bantime: 1.hour) do
          # The count for the IP is incremented if the return value is truthy.
          req.path == '/sessions' and req.post?
        end
      end
    end
  end
end
