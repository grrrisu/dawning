require 'bundler'
Bundler.setup(:default, ENV['SIM_ENV'])
require 'sim'

require 'simplecov' if %w(development test).include? ENV['SIM_ENV']

require_relative 'world'
require_relative 'vegetation'
require_relative 'player/base'
require_relative 'player/member'
require_relative 'player/admin'
require_relative 'view'
require_relative 'builder/dropzone'