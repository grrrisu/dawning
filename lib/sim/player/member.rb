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

    def init_dungeon
      puts 'sim container init_dungeon 1'
      puts 'sim container init_dungeon 1a'
      create_dungeon unless level.dungeon
      puts 'sim container init_dungeon 2'
      level.dungeon.add_player self
      puts 'sim container init_dungeon 3'
      level.dungeon.fields
    end

  private

    def create_dungeon config = nil
      puts 'create_dungeon 1'
      config ||= {dungeon: {data_file: 'default/jungle_dungeon.json'}}
      puts 'create_dungeon 2'
      level.create_dungeon config
    end

    def view_params x, y, width, height
      {
        x: x,
        y: y,
        view: @world_view.filter_slice(x, y, width, height)
      }
    end

  end
end
