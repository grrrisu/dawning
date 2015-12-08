class Test::LevelProxy

  ID = '123'
  NAME = 'admin_test_level'

  attr_reader :player

  def initialize
    LevelManager.instance.add_level('123', self)
    @player = Test::PlayerProxy.new
  end

  def players
    [@player]
  end

  def id
    ID
  end

  def name
    NAME
  end

  def find_player user_id
    @player
  end

  def state
    :stopped
  end

  def remove
    LevelManager.instance.delete ID
  end

  def as_json
    {
      id: ID,
      name: NAME,
      state: state,
      config_file: nil,
      world: {
        height: 100,
        width: 50
      },
      players: 0,
      time_unit: nil,
      sim_loop: nil,
      event_queue: nil
    }
  end

end
