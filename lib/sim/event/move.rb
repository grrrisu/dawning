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

    def needed_resources
      BotMove.move_resources(world, pawn)
    end

    def move
      change_move(pawn.x, pawn.y) do
        check_movement
        answer
      end
    end

  private

    def answer
      Hashie::Mash.new pawn_id: pawn.id, x: pawn.x, y: pawn.y
    end

    def check_movement
      headquarter.within_influence_area(x,y) do
        move_pawn(pawn, x, y) unless world[x,y].key?(:pawn)
      end
    end

    def change_move x, y
      answer = yield
      if x != answer[:x] || y != answer[:y]
        answer.merge! notify: View.move_nofitication(answer[:x], answer[:y], x, y)
      else
        answer
      end
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
