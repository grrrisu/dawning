source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'jquery-rails'
gem 'haml-rails'
gem 'simple_form'

gem "mongoid"

gem 'sorcery'
gem 'cancan'
gem 'gravtastic'
gem 'kaminari'
gem 'better_logging'

gem 'newrelic_rpm'
gem 'airbrake'

gem 'Simulator', :require => 'sim', :github => 'grrrisu/Simulator' #:path => '../Simulator'
gem 'uuid'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass'
  gem "font-awesome-rails"
end

group :development do
  gem 'thin'
  gem 'quiet_assets'
  gem 'debugger'

  gem 'rb-readline', :require => false
  gem 'guard', :require => false
  gem 'guard-rspec', :require => false
  # guard-jasmine needs PhantomJS
  # see http://code.google.com/p/phantomjs/wiki/BuildInstructions#Mac_OS_X
  gem 'guard-jasmine', :require => false
  gem 'growl', :require => false
  gem 'rb-fsevent', '~> 0.9.1', :require => false

  gem 'capistrano', :require => false
  gem 'capistrano-ext', :require => false
  gem 'rvm-capistrano', :require => false

  gem 'hirb', :require => false
  gem 'wirble', :require => false

  gem 'brakeman', :require => false
  gem 'rack-mini-profiler', :require => false # set to true to enable mini profiler
  gem 'bullet'
end

group :test, :development do
  gem "rspec-rails"
  gem "jasminerice"
  gem "spork", :require => false
  gem "guard-spork", :require => false
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'launchy'
end

group :production do
  gem 'unicorn'
end
