class Pawn

  attr_accessor :id, :x, :y, :view_radius

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
    @view_radius = 1
    @x, @y       = x, y
  end

end
