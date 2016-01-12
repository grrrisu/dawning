module Builder

  class Pawn

    attr_reader :id, :dungeon

    def initialize dungeon
      @id = 123
      @dungeon = dungeon
    end

    def place
      pawn = build_pawn
      pawn.id = 123
      pawn
    end

    def build_pawn
      x, y = dungeon.map.width / 2, dungeon.map.height / 2
      pawn = ::Dungeon::Pawn.build x: x, y: y
      dungeon.map[x, y] << pawn
      pawn
    end

  end

end
