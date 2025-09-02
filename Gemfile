source "https://rubygems.org"

ruby "3.3.4" # or your latest installed Ruby 3.3.x

# Core Rails
gem "rails", "~> 8.0.2", ">= 8.0.2.1"
gem "puma", ">= 5.0"
gem "propshaft"              # Rails 8 asset pipeline

# Database
gem "pg", "~> 1.5"           # PostgreSQL
# If you want SQLite for quick dev, add: gem "sqlite3", group: [:development, :test]

# Hotwire stack
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

# Background jobs / real-time
gem "good_job"               # Postgres-backed jobs + scheduler
# gem "solid_queue"          # Alternative, built-in Rails queue
# gem "solid_cable"          # Alternative for ActionCable

# Payments & QR
gem "stripe"                 # Stripe API
gem "rqrcode"                # QR code generation
gem "image_processing"       # for QR/image manipulation

# Optional AI / vector search
gem "openai", require: false # OpenAI API client
gem "pgvector"               # Vector extension for Postgres

# Utilities
gem "rack-cors"              # CORS (if you serve API endpoints to mobile/tablets)
gem "bootsnap", require: false

# Deployment (optional)
# gem "kamal", require: false
# gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
