module Dungeon
  class Pawn < Moveable

    attr_accessor :id

    def as_json
      { pawn_id: id, type: self.class.name }
    end

  end
end
