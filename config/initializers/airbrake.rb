if defined? Airbrake
  Airbrake.configure do |config|
    config.api_key = APP_CONFIG['airbrake_api_key']
  end
else
  puts 'Airbrake is not activated'
end