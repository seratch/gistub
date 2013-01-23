source :rubygems

gem 'rails', '3.2.11'
gem 'jquery-rails', '2.1.4'

group :sqlite do
  gem 'sqlite3', platforms: :ruby
  gem 'activerecord-jdbcsqlite3-adapter', platforms: :jruby
end

gem 'omniauth-openid', '1.0.1'
gem 'erubis',  '~> 2.7.0'
gem 'simple_form', '2.0.4'
gem 'kaminari', '0.14.1'

group :test, :development do
  gem 'factory_girl', '~> 4.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'rspec-rails', '~> 2.0'
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
end

group :assets do
  gem 'less-rails'
  gem 'twitter-bootstrap-rails', git: 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
  gem 'therubyracer', '0.10.2', platforms: :ruby
  gem 'therubyrhino', platforms: :jruby
  gem 'uglifier', '>= 1.0.3'
end
group :server do
  gem 'mizuno', platforms: :jruby
  gem 'passenger', platforms: :ruby
  gem 'thin', platforms: :ruby
end
# rails g rspec:install
# rails g simple_form:install --bootstrap
# rails g bootstrap:install
# rails g bootstrap:layout application ﬂuid
# rails g kaminari:config

