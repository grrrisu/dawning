module Dungeon
  class Actor
    include Celluloid
    include Celluloid::Logger

    attr_accessor :map

    def initialize
      reset_players
    end

    def self.instance
      @instance ||= new
    end

    def find_player player_id
      @players[player_id]
    end

    def add_player player
      @players[player.id] = player
      player.food_points = 0
      player.pawns = []
    end

    def reset_players
      @players = {}
    end

    def food_collected position, player
      info "food_collected at [#{position[:isoX]}, #{position[:isoY]}]"
      position = map.position position[:isoX], position[:isoY]
      player.food_points += map.collect_food_at(*position)
      if player.food_points == map.total_food_points
        player.dungeon_end player.food_points, 1
      else
        player.update_food_points player.food_points
      end
    end

    def attacked food_points, position, player
      info "attacked at [#{position[:isoX]}, #{position[:isoY]}]"
      player.dungeon_end player.food_points, 0
    end

    def player_moved pawn, x, y
      info "pawn [#{pawn.id}] moved to #{x} #{y}"
      if (pawn.x - x).abs > 1 ||  (pawn.y - y).abs > 1
        warn "pawn moved too far [#{pawn.x}, #{pawn.y}] to position[#{x}, #{y}]"
      end
      map[pawn.x, pawn.y].delete(pawn)
      map[x, y] << pawn
      pawn.set_position x, y
    end

  end
end
