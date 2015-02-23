source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'bootstrap-sass', '~> 3.3'
gem 'bootswatch-rails', '~> 3.2'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'devise', '~> 3.4'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'friendly_id', '~> 5.1'
gem 'aasm', '~> 4.0.8'
gem 'acts_as_votable', '~> 0.10'
gem 'draper', '~> 1.4'
gem 'js-routes', '~> 1.0'
gem 'will_paginate', '~> 3.0'
gem 'paranoia'
gem 'gravatarify', '~> 3.0'
gem 'paperclip', '~> 4.2'
gem 'foreman'
gem 'puma'

group :development do
  gem 'quiet_assets', '~> 1.1'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'faker', '~> 1.4'
  gem 'capybara', '~> 2.4'
  gem 'database_cleaner', '~> 1.4'
  gem 'launchy', '~> 2.4'
  gem 'shoulda-matchers', '~> 2.7', require: false
  gem 'capybara-email', '~> 2.4'
  gem 'capybara-webkit', '~> 1.4'
end

group :development, :production do
  gem 'aws-sdk', '< 2'
end

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'did_you_mean', '~> 0.9'
  gem 'rspec-rails', '~> 3.1'
  gem 'factory_girl_rails', '~> 4.5'
end

group :production do
  gem 'rails_12factor'
  gem 'pg'
end

ruby '2.2.0'
