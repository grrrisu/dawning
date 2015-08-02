module Player
  class Admin < Base

    attr_accessor :world

    def create config
      self
    end

    def init_map
      if @world
        { center: { x: @world.width / 2 , y: @world.height / 2 } }
      else
        false
      end
    end

    def update_view x, y, width, height
      view_params x, y, width, height
    end

    def view x, y, width, height
      super
      view_params x, y, width, height
    end

  private

    def view_params x, y, width, height
      w = Sim::Matrix.new(width, height)
      w.set_each_field_with_index do |i, j|
        @world.filter_value(0 + x + i, 0 + y + j)
      end
      {
        x: x,
        y: y,
        view: w
      }
    end

  end
end
