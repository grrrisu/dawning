module Player
  class Base < Sim::Player

    def direct_actions
      [:init_map, :view, :update_view]
    end

    def current_view= value
      self.current_view_dimension = Hashie::Mash.new x: value[:x], y: value[:y], width: value[:width], height: value[:height]
    end

    def overlap_current_view? other
      if view = current_view_dimension
        ((view.x)..(view.x + view.width)).overlaps?((other.x)..(other.x + other.width)) &&
        ((view.y)..(view.y + view.height)).overlaps?((other.y)..(other.y + other.height))
      end
    end

  end
end
