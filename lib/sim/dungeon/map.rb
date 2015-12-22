module Dungeon
  class Map < Sim::Matrix

    Banana1 = 10
    Banana2 = 25
    Banana3 = 60

    attr_reader :field_size

    def initialize
      @field_size = 65
    end

    def position iso_x, iso_y
      [
        (iso_x / field_size.to_f).floor,
        (iso_y / field_size.to_f).floor
      ]
    end

    def total_food_points
      @total_food_points ||= inject(0) do |total, field|
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

  end
end
