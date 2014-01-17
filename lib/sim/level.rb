require 'bundler'
Bundler.setup(:default)
require 'sim'

require_relative 'world'


# Level 1.0
# example: 50 x 100 fields
# 5 Zones:
# * bot dropzone 2    ( 0 - 19)
# * gateway zone      (20 - 39)
# * transit           (40 - 59)
# * players dropzone  (60 - 79)
# * bot dropzone 1    (80 - 99)
class Level < Sim::Level

  attr_reader :world, :config

  def create config
    $stderr.puts '******* BEGIN CREATING *********'

    @config  = config
    @players = {}
    $stderr.puts config
    @world = World.build(config[:world])

    $stderr.puts '******* END CREATING *********'
    true
  end

  def process_message message
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

  def load
    raise "implement in subclass"
  end

  def add_player id
    # player_supervisors_as << Sim::Player.supervise_as "player_#{id}"
    # raise "implement in subclass"
    $stderr.puts "add_player #{id.inspect}"
    view = View.new(@world, 0, 0, @world.width, @world.height)
    @players[id] = Player.create view, config[:player]

    id
  end

  def remove_player id
    # raise "implement in subclass"
  end

end
