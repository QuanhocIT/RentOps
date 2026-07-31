class Rack::Attack
  # Use MemoryStore in development/windows to prevent file locking issues in tmp/cache
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Rate limit login attempts by IP address
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  # Throttle login attempts to 5 per minute per IP
  throttle('logins/ip', limit: 5, period: 1.minute) do |req|
    if req.path == '/api/v1/auth/login' && req.post?
      req.ip
    end
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |env|
    [ 429,  { 'Content-Type' => 'application/json' }, [ { success: false, message: "Quá nhiều yêu cầu. Vui lòng thử lại sau ít phút." }.to_json ] ]
  end
end
