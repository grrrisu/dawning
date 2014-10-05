module Player
  class Base < Sim::Player

    def direct_actions
      [:init_map, :view]
    end

    def view x, y, width, height
      self.current_view_dimension = {x: x, y: y, width: width, height: height}
    end

  end
end
