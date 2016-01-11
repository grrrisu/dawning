module Dungeon
  class Tree < Thing

    default_attr :blocks_visability, true

    def as_json
      blocks_visability ? 'X' : 'x'
    end

  end
end
