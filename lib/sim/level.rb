require 'bundler'
Bundler.setup(:default)
require 'sim'

require_relative 'world'
require_relative 'player'
require_relative 'admin_view'
require_relative 'view'
require_relative 'builder/dropzone'


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
    $stderr.puts '******* BEGIN CREATING *********'

    @config  = config
    @players = {}       # maps player_id to player obj
    $stderr.puts config

    @world =    World.build(config[:world])
    @dropzone = Builder::Dropzone.new(@world, config[:dropzones])

    $stderr.puts '******* END CREATING *********'
    true
  end

  def process_message message
    if message.key? :player
      if player = find_player(message[:player])
        player.process_message message
      else
        raise ArgumentError, "no player[#{message[:player]} found in this level"
      end
    else
      case message[:action]
        when 'admin_view'
          AdminView.view @world, message[:params]
        when 'init_map'
          if @world
            { world: { width: @world.width, height: @world.height } }
          else
            false
          end
      else
        super
      end
    end
  end

  def load
    raise "implement in subclass"
  end

  def add_player id
    # player_supervisors_as << Sim::Player.supervise_as "player_#{id}"
    # raise "implement in subclass"
    $stderr.puts "add_player #{id.inspect}"

    player = dropzone.place_player
    @players[id] = player
    player.create config[:player]

    id
  end

  def find_player player_id
    @players[player_id]
  end

  def remove_player id
    # raise "implement in subclass"
  end

end
