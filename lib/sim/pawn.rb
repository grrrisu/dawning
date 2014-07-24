class Pawn
  include Sim::Buildable

  attr_accessor :id, :x, :y, :type

  default_attr :view_radius, 1

  def self.id_count
    @count ||= 0
    @count += 1
  end

  def self.add pawn
    @instances ||= {}
    pawn.id = id_count
    @instances[pawn.id] = pawn
  end

  def self.find id
    @instances.fetch(id)
  end

  def initialize x, y
    Pawn.add(self)
    @x, @y       = x, y
    @tpye        = 'base'
  end

  # the value that is returned to the view
  def view_value
    self.class.name.underscore
  end

end
