source 'https://rubygems.org'

# TODO: rails 4.2
gem 'rails', '6.1.7.3'
gem 'jquery-rails', '>= 4.4.0'
gem 'rails_autolink', '>= 1.1.6'

gem 'qiita-markdown', :platforms => :ruby
gem 'kramdown', '>= 2.3.0', :platforms => :jruby

gem 'omniauth-openid', '>= 2.0.1'
gem 'erubis'
gem 'kaminari', '>= 1.2.1'

gem 'simple_form', '>= 5.0.0'

gem 'coveralls', require: false

gem 'pg', group: :postgresql

group :development do
  # better_errors 2.0 requires Ruby 2.0 or higher
  gem 'better_errors', '2.8.0'
  gem 'magic_encoding'
  gem 'binding_of_caller', :platforms => :ruby
end

group :test, :development do
  gem 'bullet'
  gem 'pry-rails'
  gem 'sqlite3', :platforms => :ruby
  gem 'activerecord-jdbcsqlite3-adapter', :platforms => :jruby
  gem 'factory_girl'
  gem 'factory_girl_rails', '>= 4.5.0'
  # TODO: rspec 3
  gem 'rspec-rails', '2.14.2'
  gem 'rspec-kickstarter'
end

group :test do
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
end

group :assets do
  gem 'less-rails', '>= 2.6.0'
  gem 'twitter-bootstrap-rails', '>= 3.2.0'
  gem 'therubyracer', :platforms => :ruby
  gem 'therubyrhino', :platforms => :jruby
  gem 'uglifier', '>= 2.7.2'
end

group :server do
  # bin/rails s mizuno
  gem 'mizuno', :platforms => :jruby
  gem 'thin', '>= 1.7.0', :platforms => :ruby
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

