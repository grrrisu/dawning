# headless javascript testing
Capybara.javascript_driver = :webkit

Capybara.server do |app, port|
  require 'rack/handler/thin'
  Thin::Logging.silent = true
  Thin::Server.new('0.0.0.0', port, app).start
end
