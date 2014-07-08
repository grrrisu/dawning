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

  def view x, y, width, height
    w = Sim::Matrix.new(width, height)
    w.set_each_field_with_index do |i, j|
      @world[0 + x + i, 0 + y + j]
    end
    {
      x: x,
      y: y,
      view: w
    }
  end

end
