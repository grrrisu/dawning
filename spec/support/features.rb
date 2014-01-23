RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::LevelHelpers, type: :feature
end
