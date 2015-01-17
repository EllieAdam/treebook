source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'devise', '~> 3.4.1'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem 'quiet_assets', '~> 1.1.0'
end

group :test do
  gem 'faker', '~> 1.4.3'
  gem 'capybara', '~> 2.4.4'
  gem 'database_cleaner', '~> 1.4.0'
  gem 'launchy', '~> 2.4.3'
  gem 'selenium-webdriver', '~> 2.44.0'
  gem 'shoulda-matchers', '~> 2.7.0'
  gem 'capybara-email', '~> 2.4.0'
end

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'did_you_mean', '~> 0.9.5'
  gem 'rspec-rails', '~> 3.1.0'
  gem 'factory_girl_rails', '~> 4.5.0'
end

group :production do
  gem 'rails_12factor'
  gem 'pg'
end

ruby '2.2.0'
