module Builder

  class Pawn

    attr_reader :id, :dungeon

    def initialize dungeon
      @id = 123
      @dungeon = dungeon
    end

    def place
      p 10
      pawn = Dungeon::Pawn.build x: 12, y: 12
      p 11
      dungeon[12, 12] << pawn
      p 12
      pawn
    end

  end

end
