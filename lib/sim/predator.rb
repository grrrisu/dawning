class Predator < Animal

  default_attr :sim_threshold, 1.0 # does eat and move within 1 sim

  def bio_order
    :predator
  end

  def sim
    aging
    think.tap do
      eat delay
    end
  end

  def eat step
    food_eaten = @prey.try(:max_health).to_i / 2.0
    inc_health (food_eaten - needed_food) * step
    @prey = nil
  end

  def most_profitable_field fields
    biggest_prey(fields) || search_prey(fields)
  end

  def biggest_prey fields
    fields.select do |field|
      field.fauna.try(:bio_order) == :herbivore
    end.max_by do |field|
      field.fauna.max_health
    end
  end

  def search_prey fields
    fields.select do |field|
      field.fauna.nil?
    end.max_by do |field|
      field.vegetation.size
    end
  end

  def move_to target
    return unless target
    if @prey = target.fauna
      @prey.die
    end
    super
  end

end
