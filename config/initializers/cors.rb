Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*" # In production, replace with specific domain frontend

    resource "*",
      headers: :any,
      expose: ["Authorization"],
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
