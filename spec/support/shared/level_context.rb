RSpec.shared_context "level" do

  def launched_level name = nil
    name = "test-level" if name.blank?
    LevelManager.instance.create name
  end

  def built_level name = nil, config = nil
    level = launched_level(name)
    config = "test.yml" if config.blank?
    level.build(config)
    level
  end

  def running_level name = nil, config = nil
    level = built_level(name, config)
    level.start
    level
  end

  def user_joined_level user, level
    level.add_player user.id
  end

end
