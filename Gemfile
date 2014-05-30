source 'https://rubygems.org'
ruby '2.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#gem 'rails', '4.1.0'
gem 'rails', '4.1.1'
gem 'pg', '~> 0.17.1'
gem "unicorn", "~> 4.8.2"
gem "haml-rails", "~> 0.5.3"
gem "bootstrap-sass", "~> 3.1.1.0"
gem 'pg_search', '~> 0.7.3'
gem 'sidekiq', '~> 3.0.0'
gem 'oj', '~> 2.9.3'
gem 'oj_mimic_json', '~> 1.0.0'
gem 'transloadit', '~> 1.1.1'
gem 'aws-sdk', '~> 1.42.0'

gem 'sass-rails', '~> 4.0.3'
#gem 'uglifier', '>= 1.3.0'
gem 'uglifier', '~> 2.5.0'
gem 'coffee-rails', '~> 4.0.1'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

gem 'sinatra', '~> 1.4.5'
gem 'memcachier'
gem 'dalli'

gem 'newrelic_rpm', '~> 3.8.1.221', group: :production

gem 'jquery-rails', '~> 3.1.0'
gem 'turbolinks', '~> 2.2.2'
gem 'jbuilder', '~> 2.0.6'
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'faker', '~> 1.3.0'

group :development do
  gem 'spring', '~> 1.1.2'
  gem "annotate", "2.6.3"
end

group :development, :test do
  gem "rspec-rails", "~> 2.14.1"
  gem "guard-rspec", "~> 4.2.8"
  gem "spork-rails", "~> 4.0.0"
  gem "guard-spork", "~> 1.5.1"
  gem "childprocess", "~> 0.5.2"
end

group :test do
  gem 'capybara', '~> 2.2.1'
  gem "growl", "~> 1.0.3"
  gem "factory_girl_rails", "~> 4.4.1"
  gem 'minitest', "~> 5.3.2"
  gem "shoulda-matchers", "~> 2.5.0"
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.5'

# Use debugger
gem 'debugger', group: [:development, :test]

group :production do
  gem 'rails_12factor', '0.0.2'
end
