# headless javascript testing
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist

#Capybara.default_wait_time = 5

Capybara.server do |app, port|
  require 'rack/handler/thin'
  Thin::Logging.silent = true
  Thin::Server.new('0.0.0.0', port, app).start
end
