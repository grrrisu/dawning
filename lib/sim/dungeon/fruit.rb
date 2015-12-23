module Dungeon
  class Fruit

    Banana1 = 10
    Banana2 = 25
    Banana3 = 60

    include Sim::Buildable

    default_attr :capacity, Banana1
    attr_reader :food_points

    def build config
      @food_points = @capacity
    end

    def collect
      points = @food_points
      @food_points = 0
      points
    end

    def as_json
      json_capacity = case @capacity
        when Banana1 then 1
        when Banana2 then 2
        when Banana3 then 3
      end
      capacity == food_points ? json_capacity.to_s : (-json_capacity).to_s
    end

  end
end
