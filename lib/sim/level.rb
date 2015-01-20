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

  attr_reader :world, :dropzone

  def create config
    #$stderr.puts '******* BEGIN CREATING *********'

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
    if player = find_player(id)
      player.connection.close
      players.delete(id)
    else
      raise ArgumentError, "player #{id} could not be found"
    end
  end

  def as_json
    if @world
      json = {world: {height: @world.height, width: @world.width }}
    else
      json = {}
    end
    super.merge(json)
  end

  def objects_count
    objects = super
    objects.delete("Vegetation")
    @world.each_field do |field|
      vegetation_type = field.vegetation.type
      objects["Vegetation::#{vegetation_type}"] ||= 0
      objects["Vegetation::#{vegetation_type}"] += 1
    end
    objects
  end

end
