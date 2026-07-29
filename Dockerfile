# Dockerfile for RentOps Rails API & Vite Frontend
FROM ruby:3.2.2-slim

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    curl \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' \
    && bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Expose Rails server port
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
