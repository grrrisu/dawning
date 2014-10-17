require_relative '../headquarter'

module Player
  class Member < Base

    attr_accessor :headquarter
    attr_reader   :world, :world_view

    def place view, headquarter
      @world_view   = view
      @world        = view.world
      @headquarter  = headquarter
    end

    def create config
      self
    end

    def init_map
      if @world_view.world
        {
          world: { width: @world_view.world.width, height: @world_view.world.height },
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
        view: @world_view.filter_slice(x, y, width, height)
      }
    end

    def move pawn_id, x, y
      event = Event::Move.new self, pawn_id, x, y
      fire_action_event(event)
    end

  end
end
