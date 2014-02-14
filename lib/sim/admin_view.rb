class AdminView

  def self.view world, x, y, width, height
    w = Sim::Matrix.new(width, height)
    w.set_each_field_with_index do |i, j|
      world[0 + x + i, 0 + y + j]
    end
    w
  end

end
