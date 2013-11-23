require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

# figure out if spec_helper is loaded twice and from where
if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise "foo"
  rescue => e
    puts <<-MSG
  ===================================================
  It looks like spec_helper.rb has been loaded
  multiple times. Normalize the require to:

    require "spec/spec_helper"

  Things like File.join and File.expand_path will
  cause it to be loaded multiple times.

  Loaded this time from:

    #{e.backtrace.join("\n    ")}
  ===================================================
    MSG
  end
end

Spork.prefork do

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'database_cleaner'

  # headless javascript testing
  Capybara.javascript_driver = :webkit

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|

    config.expect_with :rspec do |c|
      c.syntax = :expect
    end
    config.fail_fast = true

    config.filter_run focus: true
    config.filter_run_excluding skip: true
    config.run_all_when_everything_filtered = true

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

    config.after(:each) do
      if example.exception && example.options[:wait]
        puts "Scenario failed. We wait because of wait. Press enter when you are done"
        $stdin.gets
      elsif example.exception && example.options[:irb]
        require 'irb'
        require 'irb/completion'
        ARGV.clear
        IRB.start
      end
    end

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
  end

  include Sorcery::TestHelpers::Rails

end

Spork.each_run do

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

end
