source 'https://rubygems.org'


gem 'rails', '4.2.5'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'responders', '~> 2.0'
gem "omniauth-github"
gem 'omniauth-trello'
gem 'dotenv-rails', :groups => [:development, :test]
gem 'http'
gem 'unicorn'

group :development, :test do
  gem 'pry'
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'guard-rspec', require: false
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-unicorn'
end

group :test do
  gem 'faker'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
end
