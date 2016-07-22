source 'https://rubygems.org'

gem 'rails', '~> 4.2.2'
gem 'responders'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'haml-rails'
gem 'simple_form', '~> 3.0.0'
gem 'websocket-rails'
gem 'faye-websocket', '0.10.0' # 0.10.1 confilicts with websocket-rails

gem "mongoid", "~> 4.0.0"
gem 'thin'

gem 'sorcery'
gem 'cancancan'
gem 'gravtastic'
gem 'kaminari'
gem 'pretty_formatter'

gem 'Simulator', :require => 'sim', :github => 'grrrisu/Simulator' # :path => '../Simulator'
gem 'uuid'

gem 'sprockets-rails', '~> 2.3.3'
gem 'sass-rails'
gem 'coffee-rails'
gem "sprockets-es6", require: 'sprockets/es6'
gem 'sprockets-traceur'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platform => :ruby
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass', "~> 3.2.0.2"
gem "font-awesome-sass"

group :development do
  gem 'spring'
  gem "spring-commands-rspec"

  gem 'rb-readline', :require => false
  gem 'guard', :require => false
  gem 'guard-rspec', :require => false
  # guard-jasmine needs PhantomJS
  # see http://code.google.com/p/phantomjs/wiki/BuildInstructions#Mac_OS_X
  gem 'guard-jasmine', :require => false
  gem 'growl', :require => false
  gem 'rb-fsevent', '~> 0.9.1', :require => false

  gem 'capistrano', '~> 3.3.5', :require => false
  gem 'capistrano-rbenv', :require => false
  gem 'capistrano-bundler', :require => false
  gem 'capistrano-rails', :require => false
  gem 'capistrano-thin', :require => false
  gem 'capistrano-airbrake', :require => false

  gem 'hirb', :require => false
  gem 'wirble', :require => false

  gem 'brakeman', :require => false
  gem 'rack-mini-profiler', :require => false # set to true to enable mini profiler
  gem 'bullet'
  gem 'rails_best_practices'
  gem 'smusher', :require => false
end

group :test, :development do
  gem "rspec-rails", '~> 3.2.0'
  gem "jasmine-rails"
  gem "better_errors"
  gem "binding_of_caller"
  gem 'web-console'
  gem 'pry-rails'
  gem 'byebug'
  gem 'simplecov', '~> 0.9.1', :require => false

  # check if this is still needed for phantomjs 2.0
  gem 'rails-assets-bind-polyfill', source: 'https://rails-assets.org'
end

group :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'capybara'
  gem 'poltergeist'
  gem 'selenium-webdriver', '>=2.45.0'
  gem 'database_cleaner', '1.4.1'
  gem 'launchy'
  gem "codeclimate-test-reporter", :require => false
end

group :staging, :production do
  gem 'newrelic_rpm'
  gem 'airbrake'
end
