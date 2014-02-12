require_relative 'headquarter'

class Player

  attr_accessor :headquarter, :view
  attr_reader   :world

  def initialize view, headquarter
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
    @view.filter_slice(x, y, width, height)
  end

  def move id, x, y
    pawn = Pawn.find(id) # TODO check owner
    @headquarter.within_influence_area(x,y) do
      view.fog(pawn)
      world[pawn.x, pawn.y].delete(:pawn)
      pawn.x, pawn.y = x, y
      world[x, y].merge!(pawn: pawn)
      view.unfog(pawn)
    end
    return {x: pawn.x, y:pawn.y}
  end

end
