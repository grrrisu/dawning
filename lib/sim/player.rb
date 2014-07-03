require_relative 'headquarter'

class Player < Sim::Player

  attr_accessor :headquarter, :view
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

  def view x:, y:, width:, height:
    # FIXME if the line below is removed view returns nil
    $stderr.puts("*** view params #{x} #{y} #{width} #{height}")
    return { x: x, y: y, view: @view.filter_slice(x, y, width, height) }
  end

  def move pawn_id:, x:, y:
    # FIME if the line below is removed no pawn will be found
    $stderr.puts("*** move #{pawn_id}, #{x}, #{y}")
    pawn = Pawn.find(pawn_id) # TODO check owner
    @headquarter.within_influence_area(x,y) do
      if world[x,y][:pawn].blank?
        @view.fog(pawn)
        world[pawn.x, pawn.y].delete(:pawn)
        pawn.x, pawn.y = x, y
        world[x, y].merge!(pawn: pawn)
        @view.unfog(pawn)
      end
    end
    return {pawn_id: pawn_id, x: pawn.x, y: pawn.y}
  end

end
