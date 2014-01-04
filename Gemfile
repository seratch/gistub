source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'jquery-rails'
gem 'rails_autolink'
gem 'kramdown'

gem 'omniauth-openid'
gem 'erubis'
gem 'kaminari'

gem 'simple_form'

gem 'coveralls', require: false

group :development do
  gem 'better_errors'
  gem 'magic_encoding'
  gem 'binding_of_caller', :platforms => :ruby
end

group :test, :development do
  gem 'bullet'
  gem 'pry-rails'
  gem 'sqlite3', :platforms => :ruby
  gem 'activerecord-jdbcsqlite3-adapter', :platforms => :jruby
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rspec-kickstarter'
end

group :test do
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
end

group :assets do
  gem 'less-rails'
  gem 'twitter-bootstrap-rails'
  gem 'therubyracer', :platforms => :ruby
  gem 'therubyrhino', :platforms => :jruby
  gem 'uglifier', '>= 1.0.3'
end

group :server do
  # bin/bundle exec mizuno --reloadable
  gem 'mizuno', :platforms => :jruby
  gem 'thin', :platforms => :ruby
end

# rails g rspec:install
# rails g simple_form:install --bootstrap
# rails g bootstrap:install
# rails g bootstrap:layout application ﬂuid
# rails g kaminari:config

# bundle exec rake assets:precompile RAILS_ENV=production RAILS_GROUPS=assets

# JRuby
# see: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md
# export JRUBY_OPTS=--1.9

