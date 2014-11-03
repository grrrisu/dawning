class Herbivore < Animal

  def sim
    field.vegetation.sim
    aging delay
    super
    area = think
  end

  def eat step
    eaten = food_eaten
    inc_health (eaten - needed_food) * step

    sustenance = 1.0 / 5.0
    field.vegetation.size -= (eaten / sustenance) * step
  end

  #
  #                                   max_food
  # food_eaten =  vegetation.size * --------------
  #                                 max_vegetation
  #
  #                                1
  # food_used  = food_eaten * -----------
  #                            sustenance
  #
  def food_eaten
    max_vegetation = 1300 # max size of vegetation jungle 13
    max_food = max_health / 3.0

    field.vegetation.size * max_food / max_vegetation
  end

  def most_profitable_field fields
    fields.select do |field|
      field[:fauna].nil?
    end.max_by do |field|
      field.vegetation.size
    end
  end

end
