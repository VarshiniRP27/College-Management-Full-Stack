source "https://rubygems.org"

# Rails
gem "rails", "~> 8.1.3", ">= 8.1.3.1"

# Database
gem "pg"

# Web server
gem "puma", ">= 5.0"

# Asset pipeline
gem "propshaft"

# Rails JavaScript
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# JSON
gem "jbuilder"

# Pagination
gem "pagy"

# Time zone support
gem "tzinfo-data", platforms: %i[windows jruby]

# Solid Rails components
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Performance
gem "bootsnap", require: false

# Deployment
gem "kamal", require: false
gem "thruster", require: false

# Image processing
gem "image_processing", "~> 2.1"

# Password authentication
gem "bcrypt", "~> 3.1"


# =========================
# Development & Test
# =========================

group :development, :test do
  gem "debug",
      platforms: %i[mri windows],
      require: "debug/prelude"

  gem "bundler-audit",
      require: false

  gem "brakeman",
      require: false

  gem "rubocop-rails-omakase",
      require: false
end


# =========================
# Development only
# =========================

group :development do
  gem "web-console"
end


# =========================
# Test only
# =========================

group :test do
  gem "capybara"

  gem "selenium-webdriver"
end

gem "sqlite3", "~> 2.9"

gem "sidekiq"
