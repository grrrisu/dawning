module Dungeon
  class Leopard < Moveable

    attr_accessor :uuid

    def as_json
      { uuid: uuid, type: self.class.name }
    end

  end
end
