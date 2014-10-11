require_relative 'setup'

# Level 1.0
# example: 50 x 100 fields
# 5 Zones:
# * bot dropzone 2    ( 0 - 19)
# * gateway zone      (20 - 39)
# * transit           (40 - 59)
# * players dropzone  (60 - 79)
# * bot dropzone 1    (80 - 99)
class Level < Sim::Level

  attr_reader :world, :dropzone, :config

  def create config
    #$stderr.puts '******* BEGIN CREATING *********'

    @config  = config
    #$stderr.puts config

    @world =    World.build(config[:world])
    @dropzone = Builder::Dropzone.new(@world, config[:dropzones])

    #$stderr.puts '******* END CREATING *********'
    true
  end

  def load
    raise "implement in subclass"
  end

  def build_player data
    id = data[:player_id]
    if data[:role] == 'admin'
      player = Player::Admin.new(id, self)
      player.world = @world
    else
      player = Player::Member.new(id, self)
      dropzone.place_player player
    end
    player
  end

  def add_player data
    $stderr.puts "*** build player with #{data}"
    id = data[:player_id]
    unless players[id]
      player = build_player(data)
      players[player.id] = player
    else
      raise ArgumentError, "player #{player.id} is already registered"
    end
    player
  end

  def find_player player_id
    players[player_id]
  end

  def remove_player id
    # raise "implement in subclass"
  end

end
