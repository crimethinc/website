unless Rails.env.test?
  # Only enable throttling if REDIS_URL is set
  if ENV['REDIS_URL']
    Redis.current = Redis.new(url: ENV['REDIS_URL'])
    # Rack::Attack.cache.store = Rack::Attack::StoreProxy::RedisStoreProxy.new(Redis.current)
  end

  class Rack
    class Attack
      throttle('limit requests per IP', limit: 60, period: 1.minute) do |req|
        req.ip unless req.path.start_with?('/assets')
      end
    end
  end
end
