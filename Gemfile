source 'https://rubygems.org'
ruby '2.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0.rc1'
gem 'pg', '0.17.1'
gem "unicorn", "4.8.2"
gem "haml-rails", "~> 0.5.3"
gem "bootstrap-sass", "3.1.1.0"

gem 'sass-rails', '~> 4.0.1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc

group :development do
  gem 'spring'
  gem "annotate", "2.6.2"
end

group :development, :test do
  gem "rspec-rails", "2.14.1"
  gem "guard-rspec", "4.2.8"
  gem "spork-rails", "4.0.0"
  gem "guard-spork", "1.5.1"
  gem "childprocess", "0.5.1"
end

group :test do
  gem 'capybara', '2.2.1'
  gem "growl", "1.0.3"
  gem "factory_girl_rails", "4.4.1"
  gem 'minitest'
  gem "shoulda-matchers", "~> 2.5.0"
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.5'

# Use debugger
# gem 'debugger', group: [:development, :test]

group :production do
  gem 'rails_12factor', '0.0.2'
end
