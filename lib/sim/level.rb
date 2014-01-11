require 'bundler'
Bundler.setup(:default)
require 'sim'
require_relative 'world'

class Level < Sim::Level

  attr_reader :world

  def create config
    $stderr.puts '******* BEGIN CREATING *********'

    $stderr.puts config
    @world = World.build(config[:world])

    $stderr.puts '******* END CREATING *********'
    true
  end

  def process_message message
    case message[:action]
      when 'view'
        require 'pp'
        params = message[:params]
        # TODO ??? use view and filter_slice
        x, y, width, height = params[:x], params[:y], params[:width], params[:height]
        w = Sim::Matrix.new(width, height)
        w.set_each_field_with_index do |i, j|
          #$stderr.puts x, y, i, j
          #$stderr.puts @world.size
          #$stderr.puts @world[0 + x + i, 0 + y + j]
          @world[0 + x + i, 0 + y + j]
        end
        w
    else
      super
    end
  end

  def load
    raise "implement in subclass"
  end

  def add_player id
    # player_supervisors_as << Sim::Player.supervise_as "player_#{id}"
    raise "implement in subclass"
  end

  def remove_player id
    raise "implement in subclass"
  end

end
