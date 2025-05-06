# frozen_string_literal: true

source 'https://rubygems.org'

gem 'json', '~> 2.11.3'
gem 'sequel', '~> 5.0'
gem 'sinatra', '>= 4.1.1'
gem 'sqlite3', '~> 2.6'

group :test do
  gem 'factory_bot', '~> 6.5', '>= 6.5.1'
  gem 'rspec', '~> 3.13'
end

group :development, :test do
  gem 'rubocop', '~> 1.75', '>= 1.75.5', require: false
  gem 'rubocop-rspec', '~> 3.6'
  gem 'rubocop-sequel', '~> 0.4.1'
end
