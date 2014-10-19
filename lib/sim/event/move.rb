module Event
  class Move < Sim::Queue::ActionEvent
    extend Forwardable

    attr_reader :player, :pawn, :x, :y

    def_delegators :@player, :headquarter, :world, :world_view

    def initialize player, pawn_id, x, y
      @player = player
      @pawn   = Pawn.find(pawn_id) # TODO check owner
      @x, @y  = x, y
      @action = :move
    end

    def fire
      answer = move
      respond answer
    end

    def move
      change_move(pawn.x, pawn.y) do
        headquarter.within_influence_area(x,y) do
          move_pawn(pawn, x, y) unless world[x,y].key?(:pawn)
        end
        Hashie::Mash.new pawn_id: pawn.id, x: pawn.x, y: pawn.y
      end
    end

    def needed_resources
      @resources ||= Array.new.tap do |fields|
        View.square(1) do |i, j|
          fields << world[pawn.x + i, pawn.y + j]
        end
      end
    end

  private

    def change_move x, y
      answer = yield
      if x != answer[:x] || y != answer[:y]
        answer.merge! notify: notify_message(answer, x, y)
      else
        answer
      end
    end

    def notify_message answer, x, y
      {
        x: x <= answer[:x] ? x : answer[:x],
        y: y <= answer[:y] ? y : answer[:y],
        width: (x - answer[:x]).abs + 1,
        height: (y - answer[:y]).abs + 1
      }
    end

    def move_pawn pawn, x, y
      world_view.fog(pawn)
      world[pawn.x, pawn.y].delete(:pawn)
      pawn.x, pawn.y = x, y
      world[x, y].merge!(pawn: pawn)
      world_view.unfog(pawn)
    end

  end
end
