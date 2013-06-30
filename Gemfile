source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'haml-rails'
gem 'simple_form', :github => 'plataformatec/simple_form'

gem "mongoid", :github => "mongoid/mongoid" # wait until ready for activerecord 4.0

gem 'sorcery', :github => "NoamB/sorcery" # wait until ready for rails4
gem 'cancan'
gem 'gravtastic'
gem 'kaminari'
gem 'better_logging', github: 'snow/better_logging' # patch until ready for rails 4 see https://github.com/pauldowman/better_logging/issues/11

gem 'newrelic_rpm'
gem 'airbrake'

gem 'Simulator', :require => 'sim', :github => 'grrrisu/Simulator' #:path => '../Simulator'
gem 'uuid'

gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platform => :ruby
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass'
gem "font-awesome-rails"

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
  gem "jasminerice", :github => 'bradphelan/jasminerice' # wait until ready for rails4
  gem "spork", :require => false, :github => 'sporkrb/spork' # until ready for rails4
  gem "guard-spork", :require => false
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'capybara', '~> 2.0.3' # version 2.1 needs capybara-webkit  >= 1.0
  gem 'capybara-webkit', '~> 0.14.2' # version 1.0 needs QT >= 4.8 which is not compatible with OS X 10.6
  gem 'database_cleaner'
  gem 'launchy'
end

group :production do
  gem 'unicorn'
end
