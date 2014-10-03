class AdminPlayer < BasePlayer

  attr_accessor :world

  def create config
    self
  end

  def init_map
    if @world
      { world: { width: @world.width, height: @world.height } }
    else
      false
    end
  end

  def filter_value x, y
    properties = @world[x, y]
    properties.inject({}) do |view_properties, property|
      key, value = property[0], property[1]
      view_properties[key] = value.respond_to?(:view_value) ? value.view_value : value
      view_properties
    end
  end

  def view x, y, width, height
    w = Sim::Matrix.new(width, height)
    w.set_each_field_with_index do |i, j|
      filter_value(0 + x + i, 0 + y + j)
    end
    {
      x: x,
      y: y,
      view: w
    }
  end

end
