module Dungeon
  class Leopard < Moveable

    def initialize
      @uuid = UUID.new.generate
    end

    def as_json
      { uuid: @uuid, type: self.class.name }
    end

  end
end
