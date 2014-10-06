class Vegetation < Sim::Object
  include Sim::Buildable

  TYPE = {
    13 => {
      capacity: 1300,
      birth_rate: 0.15,
      death_rate: 0.05,
      size: 650,
      view_value: 13
    },
    8 => {
      capacity: 800,
      birth_rate: 0.15,
      death_rate: 0.05,
      size: 400,
      view_value: 8
    },
    5 => {
      capacity: 500,
      birth_rate: 0.15,
      death_rate: 0.05,
      size: 250,
      view_value: 5
    },
    3 => {
      capacity: 300,
      birth_rate: 0.15,
      death_rate: 0.05,
      size: 150,
      view_value: 3
    },
    2 => {
      capacity: 200,
      birth_rate: 0.15,
      death_rate: 0.05,
      size: 100,
      view_value: 2
    },
    1 => {
      capacity: 100,
      birth_rate: 0.15,
      death_rate: 0.05,
      size: 50,
      view_value: 1
    },
    0 => {
      capacity: 20,
      birth_rate: 0.15,
      death_rate: 0.05,
      size: 10,
      view_value: 0
    }
  }

  default_attr :capacity, 1300
  default_attr :birth_rate, 0.15
  default_attr :death_rate, 0.05
  default_attr :size, 650
  default_attr :view_value, 13

  attr_accessor :x, :y

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
  def sim
    delta = @size * (birth_rate - death_rate) * (capacity - @size) / capacity
    self.size += delta * delay
    #inc :size, delta * delay
  end

  def set_coordinates x, y
    @x, @y = x, y
  end

end
