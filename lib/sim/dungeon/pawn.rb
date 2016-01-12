module Dungeon
  class Pawn < Moveable

    attr_accessor :id

    def as_json
      'P'
    end

  end
end
