class Animal < Sim::Object

  default_attr :age, 0
  default_attr :next_birth, 0
  default_attr :age_death, 30
  default_attr :health, 50
  default_attr :max_health, 100
  default_attr :birth_step, 5
  default_attr :needed_food, 15
  default_attr :max_food, 30

  attr_accessor :field

  def sim
    field.vegetation.sim
    aging delay
    super
    area = think
  end

  def calculate step
    eat(step)
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

  def inc_health delta
    self.health += delta
    self.health = max_health if health > max_health
    die! if health <= 0
  end

  def aging step
    self.next_birth += step
    self.age += step
    die! if age >= age_death
    reproduce if next_birth >= birth_step
  end

  def think
    move_to(most_profitable_field(look_around))
  end

  def most_profitable_field fields
    fields.select do |field|
      field[:fauna].nil?
    end.max_by do |field|
      field.vegetation.size
    end
  end

  def look_around
    Array.new.tap do |fields|
      View.square(1) do |i, j|
        if View.within_radius(i, j, 1)
          fields << world[field.x + i, field.y + j]
        end
      end
    end
  end

  def move_to target
    View.move_nofitication(field.x, field.y, target.x, target.y).tap do
      field.delete(:fauna)
      self.field = target
      target.merge!(fauna: self)
    end
  end

  def world
    Level.instance.world
  end

  def die!
    sim_loop.remove(self)
    field.fauna = nil
    self.field = nil
    raise Death # abort any running sim process
  end

  def reproduce
    self.next_birth -= birth_step
    free_field = world.select do |field|
      field.fauna.nil?
    end.shuffle.first
    if free_field
      free_field.fauna = self.class.build
      sim_loop.add(free_field.fauna)
    end
    # TODO fire reproduce event
    # child = self.class.build
    # fire DropEvent.new(child)
  end

  def create_event
    Event::BotMove.new(self)
  end

  def queue_up
    sim_loop.add(self)
  end

  def sim_loop
    Celluloid::Actor[:sim_loop]
  end

  def view_value
    {type: type, health: health.round, age: age.round}
  end

end
