source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Database Adapter
gem 'pg', '~> 1.1', '>= 1.1.4'
# Authentication
gem 'devise', '~> 4.7', '>= 4.7.1'
# Code style formatter
gem 'rubocop', '~> 0.72.0'
# Model serializer
gem 'fast_jsonapi', '~> 1.5'
# Cache
gem 'redis', '~> 4.1', '>= 4.1.2'
# Configure environment variable
gem 'econfig', '~> 2.1'
# Cryptography library
gem 'rbnacl', '>= 3.0.1'
gem 'rbnacl-libsodium', '~> 1.0', '>= 1.0.16'
# Authorization & Permission
gem 'cancancan', '~> 3.0', '>= 3.0.1'
# Background worker
gem 'sidekiq', '~> 5.2', '>= 5.2.7'
# State Machine
gem 'aasm', '~> 5.0', '>= 5.0.5'
# CORS
gem 'rack-cors', '~> 1.0', '>= 1.0.3'

gem 'responders', '~> 3.0'
gem 'compass-rails', github: 'Compass/compass-rails'
gem 'sprockets-rails', '~> 3.2', '>= 3.2.1'
gem 'railties', '~> 6.0.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'annotation', '~> 0.1.2'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '~> 5.0', '>= 5.0.2'
  gem 'faker', '~> 1.9', '>= 1.9.6'
  gem 'pry', '~> 0.12.2'
  gem 'rspec-rails', '~> 3.8'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.4'
  gem 'database_cleaner', '~> 1.7'
  gem 'mailcatcher'
  gem 'rack-mini-profiler', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
