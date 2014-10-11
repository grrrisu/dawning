require_relative '../headquarter'

module Player
  class Member < Base

    attr_accessor :headquarter
    attr_reader   :world

    def place view, headquarter
      @view   = view
      @world  = view.world
      @headquarter = headquarter
    end

    def create config
      self
    end

    def init_map
      if @view.world
        {
          world: { width: @view.world.width, height: @view.world.height },
          headquarter:
          {
            id: @headquarter.id,
            x: @headquarter.x,
            y: @headquarter.y,
            pawns:
              @headquarter.pawns.map do |pawn|
                {id: pawn.id, type: pawn.type, x: pawn.x, y: pawn.y}
              end
          }
        }
      else
        false
      end
    end

    def view x, y, width, height
      super
      {
        x: x,
        y: y,
        view: @view.filter_slice(x, y, width, height)
      }
    end

    def move pawn_id, x, y
      pawn = Pawn.find(pawn_id) # TODO check owner
      change_move(pawn.x, pawn.y) do
        @headquarter.within_influence_area(x,y) do
          move_pawn(pawn, x, y) if world[x,y][:pawn].blank?
        end
        {pawn_id: pawn_id, x: pawn.x, y: pawn.y}
      end
    end

  private

    def change_move x, y
      answer = yield
      if x != answer[:x] || y != answer[:y]
        answer.merge! notify: {
          x: x <= answer[:x] ? x : answer[:x],
          y: y <= answer[:y] ? y : answer[:y],
          width: (x - answer[:x]).abs + 1,
          height: (y - answer[:y]).abs + 1
        }
      else
        answer
      end
    end

    def move_pawn pawn, x, y
      @view.fog(pawn)
      world[pawn.x, pawn.y].delete(:pawn)
      pawn.x, pawn.y = x, y
      world[x, y].merge!(pawn: pawn)
      @view.unfog(pawn)
    end

  end
end
