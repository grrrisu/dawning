require_relative 'builders/world_builder'

class World < Sim::Matrix
  include Sim::Buildable

  def initialize width, height
    super(width, height) # map width and height to columns and rows
  end

  def build config
    builder = WorldBuilder.new(self)
    builder.create(config)
  end

end
