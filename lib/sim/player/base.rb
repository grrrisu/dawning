module Player
  class Base < Sim::Player

    def direct_actions
      [:init_map, :view]
    end

    def view x, y, width, height
      self.current_view_dimension = Hashie::Mash.new x: x, y: y, width: width, height: height
    end

    def overlap_current_view? other
      view = current_view_dimension
      ((view.x)..(view.x + view.width)).overlaps?((other.x)..(other.x + other.width)) &&
      ((view.y)..(view.y + view.height)).overlaps?((other.y)..(other.y + other.height))
    end

  end
end
