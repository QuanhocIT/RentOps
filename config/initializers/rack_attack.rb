class Rack::Attack
  # Throttle login attempts by IP address
  throttle("auth/login/ip", limit: 10, period: 1.minute) do |req|
    req.ip if req.path == "/api/v1/auth/login" && req.post?
  end

  # Throttle general API requests by IP address
  throttle("api/ip", limit: 300, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  # Throttle webhook calls by IP
  throttle("webhooks/vietqr/ip", limit: 60, period: 1.minute) do |req|
    req.ip if req.path == "/api/v1/webhooks/vietqr" && req.post?
  end
end
