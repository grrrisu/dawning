# vegetation represents the main flora type
# resoucres are trees, grass, foliage, branches, roots, weed
class Vegetation < Sim::Object

  default_attr :capacity, 1300
  default_attr :birth_rate, 0.15
  default_attr :death_rate, 0.05
  default_attr :size, 650
  default_attr :type, 13

  attr_reader :field

  def field= field
    @field           = field
    field.vegetation = self
  end

  # resource grows by birth rate (alias grow rate) and shrinks by natural deaths (age),
  # the resource size is limited by the capacity (available room, sun energy)
  #
  # b : birth_rate
  # d : death_rate
  # C : capacity
  # s : size
  #
  # Δ &#916;
  #
  #                (C - s)
  # Δs = s (b - d) -------
  #                  C
  def calculate step
    delta = @size * (birth_rate - death_rate) * (capacity - @size) / capacity
    self.size += delta * step
  end

  def changed_area
    #inc :size, delta_size
    $stderr.print "+"
    Hashie::Mash.new(x: field.x, y: field.y, width: 1, height: 1)
  end

  def queue_up
    Celluloid::Actor[:sim_loop].add(self)
  end

  def create_event
    Event::SimField.new(self)
  end

  def view_value
    {type: type, size: size.round}
  end

end
