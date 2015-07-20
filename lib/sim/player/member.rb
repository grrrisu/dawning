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
          headquarter:
          {
            id: @headquarter.id,
            x: @headquarter.x,
            y: @headquarter.y,
            type: @headquarter.type,
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

    def update_view x, y, width, height
      view_params x, y, width, height
    end

    def view x, y, width, height
      super
      view_params x, y, width, height
    end

    def move pawn_id, x, y
      event = Event::Move.new self, pawn_id, x, y
      fire_action_event(event)
    end

  private

    def view_params x, y, width, height
      {
        x: x,
        y: y,
        view: @world_view.filter_slice(x, y, width, height)
      }
    end

  end
end
