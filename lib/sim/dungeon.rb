class Dungeon < Sim::Matrix

  Banana1 = 10
  Banana2 = 25
  Banana3 = 60

  attr_reader :field_size

  def initialize
    @players    = {}
    @field_size = 65
  end

  def load
    self.matrix =
    [
      ['X', 'X', 'X', 'X', 'X', 'X', '.', 'X', 'X', 'X', 'X', 'X', '.', 'X', 'X', 'X', 'X', 'X', '.', 'X', 'X', 'X', 'X', 'X', 'X'],
      ['X', '2', '.', 'X', '.', '.', '.', '.', 'X', '.', '.', '.', '.', '.', '.', '.', 'x', 'X', '.', '.', '.', '.', 'X', 'x', 'X'],
      ['X', '.', '.', 'X', 'X', '1', '.', 'X', 'X', 'X', '.', 'X', 'X', 'X', '.', '.', '3', 'X', 'X', 'X', '.', '.', 'X', '2', 'X'],
      ['X', '.', 'R', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', 'X', '.', 'X', 'X', 'x', '.', '.', '.', '.', '.', '.', 'X'],
      ['X', 'X', 'X', '.', 'X', 'X', 'X', '.', 'X', 'X', 'X', 'x', '.', 'X', 'R', '.', '.', '.', '.', '.', '.', 'X', '.', '.', 'X'],
      ['X', 'x', 'X', '.', '.', 'X', '3', '.', 'X', '.', '.', 'X', '.', '2', '.', '1', 'X', 'X', '.', '.', 'X', 'X', '.', '.', 'X'],
      ['.', '.', 'X', '.', '.', '.', '.', '.', 'X', '.', '.', 'X', '.', '.', '.', '.', '.', 'X', '.', '.', 'X', '.', '.', '.', '.'],
      ['X', '.', 'X', '.', '.', 'X', '.', '.', '.', '.', 'R', '.', '.', 'X', '.', '.', '.', 'X', '.', '1', 'X', '.', '.', '.', 'X'],
      ['X', '.', '.', '.', 'X', 'X', '.', 'X', '.', '.', 'X', 'X', 'X', 'X', 'X', 'X', '.', '.', '.', '.', '.', '.', 'L', '.', 'X'],
      ['X', '1', 'X', '.', '.', '.', '.', 'X', '1', '.', '.', 'X', '1', '.', '.', 'X', '.', '.', '.', '.', '.', '.', 'X', 'X', 'X'],
      ['X', '.', 'X', 'X', '.', '.', 'X', 'X', 'X', 'X', '.', '.', '.', '.', '.', '.', '.', 'X', 'X', 'X', '.', '.', 'X', '3', 'X'],
      ['X', '.', '.', '.', '.', '.', '.', 'X', '.', '.', 'R', '.', '.', 'X', 'X', '.', '.', '.', 'X', '.', '.', '.', 'X', '.', 'X'],
      ['.', '.', '.', 'X', 'X', '.', '.', '.', '.', 'X', 'X', '.', '.', '.', 'X', 'X', 'X', '.', 'X', '.', 'R', '.', '.', '.', '.'],
      ['X', '.', '.', '.', 'X', '.', 'x', 'X', '.', '.', 'X', '.', '.', '.', 'X', '.', '.', '.', 'X', '.', 'X', 'X', '.', '.', 'X'],
      ['X', '2', '.', '.', 'X', '.', 'X', 'X', 'X', '.', 'X', 'X', 'X', 'X', 'X', '1', '.', '.', '.', '.', '.', 'X', '.', '.', 'X'],
      ['X', '.', '.', '1', 'X', '.', '.', 'X', '.', '.', 'X', '3', '.', 'x', 'X', 'X', 'X', '.', '.', '.', '.', '.', '.', '2', 'X'],
      ['X', '.', '.', 'X', 'X', 'X', '.', '2', '.', 'X', 'X', '.', '.', '.', '.', '.', '.', '.', 'X', '1', '.', 'X', 'X', 'X', 'X'],
      ['X', '.', '.', '.', '.', '.', '.', '.', '.', '.', 'X', '.', 'x', '.', '.', 'X', '2', '.', 'X', '.', '.', '.', '.', '.', 'X'],
      ['.', '.', 'R', '.', 'X', '.', '.', 'x', 'X', '.', '.', '.', 'X', '.', '.', 'X', 'X', 'X', 'X', 'X', 'X', '.', 'X', '.', '.'],
      ['X', 'X', 'X', '.', 'X', 'X', '.', 'X', 'X', '.', 'X', '.', 'X', '.', 'X', 'X', '.', '.', '.', '.', '.', '.', 'X', '.', 'X'],
      ['X', '.', '.', '.', '.', '.', '.', '.', '.', '.', 'X', 'R', '.', '.', '.', '.', '.', 'X', '.', '.', '.', '1', 'x', 'x', 'X'],
      ['X', '.', 'X', 'X', '.', 'X', 'X', 'X', '.', 'x', 'X', 'X', '.', '.', '.', '.', '1', 'X', 'X', '.', '.', 'X', 'X', 'X', 'X'],
      ['X', '.', 'x', 'X', '.', '3', 'X', '.', '.', '.', '.', '.', '.', '.', 'X', '.', 'X', 'X', '.', '.', '.', '.', '.', '.', 'X'],
      ['X', '3', '.', 'X', '.', '.', '.', '.', '1', '.', 'X', '1', '.', '.', 'X', 'R', '.', '.', '.', '.', 'X', '2', 'X', '3', 'X'],
      ['X', 'X', 'X', 'X', 'X', 'X', '.', 'X', 'X', 'X', 'X', 'X', '.', 'X', 'X', 'X', 'X', 'X', '.', 'X', 'X', 'X', 'X', 'X', 'X'],
    ]
    self
  end

  def self.instance
    @instance ||= new
  end

  def find_player user_id
    @players[user_id]
  end

  def add_player player
    @players[player.user.id] = player
    player.food_points = 0
  end

  def map_position iso_x, iso_y
    [
      (iso_x / field_size.to_f).floor,
      (iso_y / field_size.to_f).floor
    ]
  end

  def total_food_points
    inject(0) do |total, field|
      total += food_points_for field
    end
  end

  def food_points_at x, y
    food_points_for self[x, y]
  end

  def collect_food_at x, y
    food = food_points_at x, y
    if food > 0
      self[x, y] = '0'
    end
    food
  end

  def food_points_for field
    case field
    when '1' then Banana1
    when '2' then Banana2
    when '3' then Banana3
    else 0
    end
  end

  def food_collected message, player
    position = map_position message[:position][:isoX], message[:position][:isoY]
    player.food_points += collect_food_at(*position)
    if player.food_points == total_food_points
      logger.info "WIN!!! all available food collected"
      player.save_points
    end
    player.food_points
  end

  def game_over message, player
    logger.info "GAME OVER!!! food collected: #{player.food_points}"
    player.save_points
  end

end
