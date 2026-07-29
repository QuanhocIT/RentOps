source "https://rubygems.org"

ruby ">= 3.2.0"

gem "rails", "~> 8.0.0"

# Database
gem "mysql2", "~> 0.5.5"
gem "tzinfo-data", platforms: %i[ mingw x64_mingw mswin mswin64 jruby ]
gem "fiddle"

# Multi-tenancy & Soft Delete
gem "acts_as_tenant", "~> 1.0"
gem "discard", "~> 1.3"

# Auth & JWT Security
gem "devise", "~> 4.9"
gem "devise-jwt", "~> 0.11"
gem "rack-attack", "~> 6.7"
gem "rack-cors"

# Background Processing & Cache
gem "sidekiq", "~> 7.2"
gem "redis", "~> 5.1"

# JSON & API Utilities
gem "puma", "~> 6.0"
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mingw x64_mingw ]
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "listen", "~> 3.3"
end
