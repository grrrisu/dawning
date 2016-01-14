require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'simplecov'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require Rails.root.join('spec', 'support', 'page_objects', 'application_page')
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

require 'logger'
Celluloid.logger = ::Logger.new(Rails.root.join 'log', 'level_test_celluloid.log')

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

  config.after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do
    LevelManager.instance.levels.each do |level|
      # check if connection is not a RSpec double
      if level.connection.instance_of?(Sim::Net::ParentConnection)
        level.stop rescue nil
        level.remove rescue nil
      end
    end
  end

  config.before(:each) do
    #Celluloid.logger = nil
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # helpers
  config.include SimHelper
end

include Sorcery::TestHelpers::Rails
