require 'bundler'
Bundler.setup(:default)
require 'sim'
require_relative 'world'

class Level < Sim::Level

  attr_reader :world

  def create config
    $stderr.puts '******* BEGIN CREATING *********'

    @world = World.build(config['world'])

    $stderr.puts '******* END CREATING *********'
    true
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
