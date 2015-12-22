module Dungeon
  class Tree

    include Sim::Buildable

    default_attr :blocks_visability, true

    def as_json
      blocks_visability ? 'X' : 'x'
    end

  end
end
