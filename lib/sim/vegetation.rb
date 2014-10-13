class Vegetation < Sim::Object
  include Sim::Buildable

  default_attr :capacity, 1300
  default_attr :birth_rate, 0.15
  default_attr :death_rate, 0.05
  default_attr :size, 650
  default_attr :view_value, 13

  attr_accessor :field

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
  def calculate
    delta = @size * (birth_rate - death_rate) * (capacity - @size) / capacity
    self.size += delta * delay
    $stderr.print "+"
    Hashie::Mash.new(x: field.x, y: field.y, width: 1, height: 1)
    #inc :size, delta * delay
  end

  def queue_up
    Celluloid::Actor[:sim_loop].add(self)
  end

end
