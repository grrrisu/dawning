module Dungeon
  class Moveable < Thing

    attr_reader :x, :y

    def initialize x, y
      set_position x, y
    end

    def get_position
      [@x, @y]
    end

    def set_position x, y
      @x, @y = x, y
    end

  end
end
