source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rack'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'
# Use sqlite3 as the database for Active Record
gem 'mysql2'
# Use Puma as the app server
#gem 'puma', '~> 3.7'
gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'angular-rails-templates'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'sprockets'
gem 'sprockets-rails', :require => 'sprockets/railtie'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

#Async task manager
gem 'sidekiq'
#gem 'rerun'

#File management
gem 'carrierwave', '~> 1.0'
#Pagination
gem 'kaminari'
#
gem 'figaro'
#Account security
gem 'devise', :git => 'git@github.com:plataformatec/devise.git'
gem 'devise-async'
gem 'doorkeeper', '~> 4.2.5'
#RESTful API
gem 'grape'
#gem 'grape-doorkeeper'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'hashie-forbidden_attributes'
#Role management for accounts
gem 'rolify'
#Ability management for accounts
gem 'cancancan'
#oauth2 for grape
gem 'wine_bouncer', '~> 1.0.1'
#Tags and Labels
gem 'acts-as-taggable-on', '~> 4.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'grape-rails-routes'
end

group :development do
  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.3'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #gem 'rails-dev-tweaks'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'#, platforms: [:mingw, :mswin, :x64_mingw, :jruby]
