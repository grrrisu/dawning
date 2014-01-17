require_relative 'headquarter'

class Player

  attr_accessor :headquarter, :view

  def initialize view
    @view = view
  end

  def create config
    @headquarter = Headquarter.new(24, 70)
    @headquarter.create_pawns
    view.unfog(@headquarter)
    @headquarter.pawns.each {|pawn| view.unfog(pawn) }
    self
  end

  def process_message message
    case message[:action]
      when 'init_map'
        if @view.world
          {
            world: { width: @view.world.width, height: @view.world.height },
            headquarter:
            {
              x: @headquarter.x,
              y: @headquarter.y,
              pawns: []
            }
          }
        else
          false
        end
      when 'view'
        params = message[:params]
        @view.filter_slice(params[:x], params[:y], params[:width], params[:height])
      else
        raise ArgumentError, "unknown message #{message}"
      end
  end

end
