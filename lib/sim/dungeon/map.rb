module Dungeon
  class Map < Sim::Matrix

    attr_reader :field_size

    def initialize size
      super
      @field_size = 65
    end

    def as_json
      json_map = Sim::Matrix.new width, height, '.'
      each_field_with_index do |field, x, y|
        json_map[x, y] = field.as_json if field
      end
      json_map
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
      fruit = self[x,y]
      if fruit.instance_of?(Dungeon::Fruit)
        fruit.collect
      else
        0
      end
    end

    def food_points_for field
      if field.instance_of? Dungeon::Fruit
        field.capacity
      else
        0
      end
    end

  end
end
