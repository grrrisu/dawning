require 'rubygems'

unless ENV['DRB']
  puts 'simplecov without DRB'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/config/'
    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Helpers', 'app/helpers'
    add_group 'Libraries', 'lib'
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'

# headless javascript testing
Capybara.javascript_driver = :webkit

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/features/*.rb")].each {|f| require f} # require features first
Dir[Rails.root.join("spec/support/*.rb")].each {|f| require f}

RSpec.configure do |config|

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.fail_fast = false

  config.filter_run focus: true
  config.filter_run_excluding skip: true
  config.run_all_when_everything_filtered = true

  # set metadata type (eg. controller, model, feature) corresponding to the location/dir of the spec file
  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do |example|
    if example.exception
      puts "\e[0;31m#{example.exception}"
      puts example.exception.backtrace.reject {|line| line =~ /\/gems\//}.join("\n")
      puts "\e[0m"
      if example.metadata[:wait]
        puts "Scenario failed. We wait because of wait. Press enter when you are done"
        $stdin.gets
      elsif example.metadata[:pry]
        require 'pry'
        binding.send(:pry)
      end
    end
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # helpers
  require Rails.root.join('spec', 'support', 'sim_helper')
  config.include SimHelper
end

Capybara.server do |app, port|
  require 'rack/handler/thin'
  Thin::Logging.silent = true
  Thin::Server.new('0.0.0.0', port, app).start
end

include Sorcery::TestHelpers::Rails

# --- end prefork ---

if ENV['DRB']
  puts 'simplecov with DRB'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/config/'
    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Helpers', 'app/helpers'
    add_group 'Libraries', 'lib'
  end
end

require Rails.root.join('spec', 'support', 'page_objects', 'application_page')
Dir[Rails.root.join("spec/support/features/*.rb")].each {|f| require f} # require features first
Dir[Rails.root.join("spec/support/page_objects/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/support/*.rb")].each {|f| require f}
