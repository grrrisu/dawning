require_relative '../headquarter'

module Player
  class Member < Base

    attr_accessor :headquarter
    attr_reader   :world, :world_view
    attr_accessor :food_points

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
            view_radius: @headquarter.view_radius,
            pawns:
              @headquarter.pawns.map do |pawn|
                {id: pawn.id, type: pawn.type, x: pawn.x, y: pawn.y, view_radius: pawn.view_radius}
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

    def view x, y, width, height, current_view
      self.current_view = current_view
      view_params x, y, width, height
    end

    def move pawn_id, x, y
      event = Event::Move.new self, pawn_id, x, y
      fire_action_event(event)
    end

    # --- FIXME extract dungeon ---

    # incoming and outgoing message
    def init_dungeon
      level.create_dungeon unless level.dungeon
      level.dungeon.add_player(self) unless level.dungeon.find_player(id)
      {food_points: food_points, fields: level.dungeon.map.as_json}
    end

    # incoming message
    def food_collected position
      level.dungeon.async.food_collected position, self
    end

    # incoming message
    def attacked food_points, position
      level.dungeon.async.attacked food_points, position, self
    end

    # outgoing message
    def update_food_points food_points
      connection.send_message :update_food_points, { food_points: food_points }
    end

    # outgoing message
    def dungeon_end food_points, rank
      connection.send_message :dungeon_end, { food_points: food_points, rank: rank }
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
