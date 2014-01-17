class AdminView

  def self.view world, params
    x, y, width, height = params[:x], params[:y], params[:width], params[:height]
    w = Sim::Matrix.new(width, height)
    w.set_each_field_with_index do |i, j|
      world[0 + x + i, 0 + y + j]
    end
    w
  end

end
