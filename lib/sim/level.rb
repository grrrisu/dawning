require 'bundler'
Bundler.setup(:default)
require 'sim'

class Level < Sim::Level

  def create(config)
    $stderr.puts '******* CREATING *********'
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
