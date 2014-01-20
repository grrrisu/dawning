# the view acts as a filter on the partial of the world
# everything not
class View < Sim::Matrix

  def self.within_radius dx, dy, radius, border = 1
    return false if dx > radius || dy > radius
    (dx**2 + dy**2) <= (radius**2 + border)
  end

  # field properties
  # count: how many pawns have this field in their view range

  attr_accessor :world, :x, :y, :user_id

  def initialize world, x, y, width, height = nil
    super width, height, 0
    @world = world
    # left top position of the view on the world
    @x, @y = x, y
  end

  def visible?(x,y)
    self[x,y].to_i > 0
  end

  def filter_value x, y
    properties = @world[x, y]
    properties.inject({}) do |view_properties, property|
      key, value = property[0], property[1]
      view_properties[key] = value.respond_to?(:view_value) ? value.view_value : value
      view_properties
    end
  end

  def filter
    @w ||= Sim::Matrix.new(width, height)
    @w.set_each_field_with_index do |x, y|
      visible?(x,y) ? filter_value(@x + x, @y + y) : nil
    end
    @w
  end

  def filter_slice(x, y, width, height)
    width  = x + width  > self.width ? self.width - x : width
    height = y + height > self.height ? self.height - y : height
    w = Sim::Matrix.new(width, height)
    w.set_each_field_with_index do |i, j|
      visible?(x + i, y + j) ? filter_value(@x + x + i, @y + y + j) : nil
    end
    w
  end

  def unfog pawn
    view_radius(pawn) do |x, y|
      self[x, y] += 1
    end
  end

  def fog pawn
    view_radius(pawn) do |x, y|
      self[x, y] -= 1
    end
  end

private

  def view_radius pawn
    rx, ry = pawn.x - x, pawn.y - y
    (-pawn.view_radius..pawn.view_radius).each do |j|
      (-pawn.view_radius..pawn.view_radius).each do |i|
        if View.within_radius(i, j, pawn.view_radius)
          yield rx + i, ry + j
        end
      end
    end
  end

end
