source 'https://rubygems.org'

ruby "2.3.0"

gem 'rails', '4.2.7'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'faker'

group :production do
  gem 'pg'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'capistrano',         "~> 3.6"
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  # gem 'capistrano3-puma',   require: false
end

group :development do
  gem 'sqlite3'
end

# gem 'thin'
# gem 'puma', '~> 3.6.0'
# gem 'unicorn','~> 5.1.0'
# gem 'passenger', '~> 5.0.30', require: 'phusion_passenger/rack_handler'
