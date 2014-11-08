class Animal < Sim::Object

  default_attr :age, 0
  default_attr :next_birth, 0
  default_attr :age_death, 30
  default_attr :health, 50
  default_attr :max_health, 100
  default_attr :birth_step, 5
  default_attr :needed_food, 15
  default_attr :max_food, 30

  attr_reader :field

  def field= field
    field.fauna = self
    @field      = field
  end

  def calculate step
    eat(step)
  end

  def inc_health delta
    self.health += delta
    self.health = max_health if health > max_health
    die! if health <= 0
  end

  def aging
    self.next_birth += delay
    self.age += delay
    die! if age >= age_death
    reproduce if next_birth >= birth_step
  end

  def think
    move_to(most_profitable_field(look_around))
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
    return unless target
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
    area = Hashie::Mash.new(x: field.x, y: field.y, width: 1, height: 1)
    @field.fauna = nil
    @field = nil
    raise Death.new area
  end

  def reproduce
    self.next_birth -= birth_step
    free_field = world.select do |field|
      field.fauna.nil?
    end.shuffle.first
    if free_field
      child = self.class.build
      child.field = free_field
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
