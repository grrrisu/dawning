module Dungeon
  class Map < Sim::Matrix

    attr_reader :field_size

    def initialize size
      super
      set_each_field_with_index {|x, y| Array.new }
      @field_size = 65
    end

    def as_json
      json_map = Sim::Matrix.new width, height, '.'
      each_field_with_index do |field, x, y|
        json_map[x, y] = field.as_json if field.any?
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
      if fruit = get_fruit(self[x,y])
        fruit.collect
      else
        0
      end
    end

    def food_points_for field
      if fruit = get_fruit(field)
        fruit.capacity
      else
        0
      end
    end

    def get_fruit field
      field.detect {|thing| thing.instance_of? Dungeon::Fruit}
    end

  end
end
