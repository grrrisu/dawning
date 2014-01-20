require_relative 'headquarter'

class Player

  attr_accessor :headquarter, :view
  attr_reader   :world

  def initialize view
    @view   = view
    @world  = view.world
  end

  def create config
    @headquarter = Headquarter.new(24, 70)
    world[24, 70].merge!(pawn: @headquarter)
    @headquarter.create_pawns
    view.unfog(@headquarter)
    @headquarter.pawns.each do |pawn|
      view.unfog(pawn)
      world[pawn.x, pawn.y].merge!(pawn: pawn)
    end
    self
  end

  def process_message message
    params = message[:params]
    case message[:action]
      when 'init_map'
        if @view.world
          {
            world: { width: @view.world.width, height: @view.world.height },
            headquarter:
            {
              id: @headquarter.id,
              x: @headquarter.x,
              y: @headquarter.y,
              pawns:
              [
                {id: @headquarter.pawns[0].id, type: 'base', x: @headquarter.pawns[0].x, y: @headquarter.pawns[0].y},
                {id: @headquarter.pawns[1].id, type: 'base', x: @headquarter.pawns[1].x, y: @headquarter.pawns[1].y}
              ]
            }
          }
        else
          false
        end
      when 'view'
        @view.filter_slice(params[:x], params[:y], params[:width], params[:height])
      when 'move'
        move(params[:id].to_i, params[:x], params[:y])
      else
        raise ArgumentError, "unknown message #{message}"
      end
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
