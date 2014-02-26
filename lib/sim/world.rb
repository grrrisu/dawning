require_relative 'builder/world'

class World < Sim::Matrix
  include Sim::Buildable

  def initialize width, height = nil
    super(width, height) # map width and height to columns and rows
    set_each_field { Sim::FieldProperties.new }
  end

  def build config
    builder = Builder::World.new(self)
    builder.create(config[:builder]) if config[:builder]
    self
  end

  def check_bounderies x, y
    x = width() -1 if x < 0
    y = height() -1 if y < 0
    x = 0 if x >= width
    y = 0 if y >= height
    [x, y]
  end

end
