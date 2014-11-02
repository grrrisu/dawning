class Predator < Animal

  default_attr :sim_threshold, 1.0 # does eat and move within 1 sim

  def sim
    aging delay
    area = think
    eat delay
    area
  end

  def eat step
    food_eaten = @prey.try(:max_health).to_i / 2.0
    inc_health (food_eaten - needed_food) * step
    @prey = nil
  end

  def most_profitable_field fields
    fields.select do |field|
      field[:fauna].present?
    end.max_by do |field|
      field.fauna.try(:max_health)
    end
  end

  def move_to target
    if @prey = target.fauna
      target.fauna = nil
    end
    super
  end

end
