module Dungeon
  class Leopard < Moveable

    default_attr :view_radius, 4

    attr_accessor :uuid

    def as_json
      { uuid: uuid, type: self.class.name }
    end

    def think(map)
      prey = search_prey(map)
      if prey.any?
        roar
        hunt prey.first
      end
    end

    def search_prey(map)
      prey = []
      map.ray_cast x: x, y: y, radius: view_radius do |x, y|
        field = map[x, y]
        if pawn = field.detect {|thing| thing.is_a? Pawn }
          prey << pawn
        end
      end
      prey.uniq
    end

    def roar
      puts 'roar'
    end

    def hunt prey
      p prey
    end

  end
end
