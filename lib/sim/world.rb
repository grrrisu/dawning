require_relative 'builder/world'

class World < Sim::Matrix
  include Sim::Buildable

  def initialize width, height = nil
    super(width, height) # map width and height to columns and rows
  end

  def build config
    builder = Builder::World.new(self)
    builder.create(config[:builder]) if config[:builder]
    self
  end

end
