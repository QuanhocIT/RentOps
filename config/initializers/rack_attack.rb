class Rack::Attack
  # Rate limit API requests per IP (100 reqs/min)
  throttle("req/ip", limit: 100, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  # Throttle authentication attempts (5 login reqs/min per IP)
  throttle("logins/ip", limit: 5, period: 1.minute) do |req|
    if req.path == "/api/v1/auth/login" && req.post?
      req.ip
    end
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |_env|
    [
      429,
      { "Content-Type" => "application/json" },
      [{ success: false, message: "Quá nhiều yêu cầu. Vui lòng thử lại sau.", data: nil, meta: {} }.to_json]
    ]
  end
end
