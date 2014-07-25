require 'rubygems'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'lib'
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'

require Rails.root.join('spec', 'support', 'page_objects', 'application_page')
Dir[Rails.root.join("spec/support/features/*.rb")].each {|f| require f} # require features first
Dir[Rails.root.join("spec/support/page_objects/*.rb")].each {|f| require f}
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

  config.after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # helpers
  #require Rails.root.join('spec', 'support', 'sim_helper')
  config.include SimHelper
end

include Sorcery::TestHelpers::Rails
