require_relative 'headquarter'
require_relative 'view'

class Player

  attr_accessor :headquarter, :view

  def create view, config
    @headquarter = Headquarter.new(24, 70)
    @headquarter.create_pawns
    @view = view
    view.unfog(@headquarter)
    @headquarter.pawns.each {|pawn| view.unfog(pawn) }
  end

  def process_message message
    case message[:action]
      when 'view'
        params = message[:params]
        @view.filter_slice(params[:x], params[:y], params[:width], params[:height])
      else
        raise ArgumentError, "unknown message #{message}"
      end
  end

end
