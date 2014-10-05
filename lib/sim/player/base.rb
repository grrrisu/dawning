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
      horizontal_range = (view.x)..(view.x + view.width)
      vertical_range   = (view.y)..(view.y + view.height)
      return true if horizontal_range.include?(other.x) &&
                     vertical_range.include?(other.y)
      return true if horizontal_range.include?(other.x + other.width) &&
                     vertical_range.include?(other.y)
      return true if horizontal_range.include?(other.x) &&
                     vertical_range.include?(other.y + other.height)
      return true if horizontal_range.include?(other.x + other.width) &&
                     vertical_range.include?(other.y + other.height)
      false
    end

  end
end
