class Test::LevelProxy

  ID = '123'
  NAME = 'admin_test_level'

  def initialize
    ::LevelProxy.add_level('123', self)
    @player = Test::PlayerProxy.new
  end

  def id
    ID
  end

  def find_player user_id
    @player
  end

end
