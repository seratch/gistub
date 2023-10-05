source 'https://rubygems.org'

# TODO: rails 4.2
gem 'rails', '7.1.0'
gem 'jquery-rails', '>= 4.0.1'
gem 'rails_autolink', '>= 1.1.7'

gem 'qiita-markdown', :platforms => :ruby
gem 'kramdown',       :platforms => :jruby

gem 'omniauth-openid'
gem 'erubis'
gem 'kaminari', '>= 0.16.2'

gem 'simple_form', '>= 4.0.0'

gem 'coveralls', require: false

gem 'pg', group: :postgresql

group :development do
  # better_errors 2.0 requires Ruby 2.0 or higher
  gem 'better_errors', '2.3.0'
  gem 'magic_encoding'
  gem 'binding_of_caller', :platforms => :ruby
end

group :test, :development do
  gem 'bullet'
  gem 'pry-rails'
  gem 'sqlite3', :platforms => :ruby
  gem 'activerecord-jdbcsqlite3-adapter', :platforms => :jruby
  gem 'factory_girl'
  gem 'factory_girl_rails', '>= 4.6.0'
  # TODO: rspec 3
  gem 'rspec-rails', '2.99.0'
  gem 'rspec-kickstarter'
end

group :test do
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
end

group :assets do
  gem 'less-rails', '>= 2.7.0'
  gem 'twitter-bootstrap-rails', '>= 3.2.2'
  gem 'therubyracer', :platforms => :ruby
  gem 'therubyrhino', :platforms => :jruby
  gem 'uglifier', '>= 1.0.3'
end

group :server do
  # bin/rails s mizuno
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

