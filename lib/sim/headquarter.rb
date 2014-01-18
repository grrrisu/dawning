require_relative 'pawn'

class Headquarter < Pawn

  attr_accessor :pawns, :view

  def initialize x, y
    super x, y
    self.view_radius = 2
    @pawns = []
  end

  def max_view_radius
    pawn_radius = pawns.max_by{|p| p.view_radius }.view_radius
    view_radius + pawn_radius
    # self.view = View.new(world, x - r, y - r, r * 2 + 1)
  end

  def within_influence_area x, y
    dx, dy = self.x - x, self.y - y
    if View.within_radius(dx, dy, view_radius)
      yield
    else
      $stderr.puts "movement[#{dx},#{dy}] not within influence area[#{view_radius}, #{x}, #{y}] "
    end
  end

  def create_pawns
    @pawns << Pawn.new(x+1, y)
    @pawns << Pawn.new(x-1, y)
  end

end
