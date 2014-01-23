module Features
  module LevelHelpers

    def launched_level name = nil
      name = "test-level" if name.blank?
      LevelProxy.create name
    end

    def built_level name = nil, config = nil
      level = launched_level(name)
      config = "default.yml" if config.blank?
      level.build(config)
      level
    end

    def running_level name = nil, config = nil
      level = built_level(name, config)
      level.start
      level
    end

  end
end
