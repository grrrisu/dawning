class Animal < Sim::Object

  default_attr :age, 0
  default_attr :age_death, 30
  default_attr :health, 50
  default_attr :max_health, 100
  default_attr :birth_step, 5
  default_attr :next_birth, 0
  default_attr :needed_food, 20
  default_attr :max_food, 30

  attr_accessor :field

  def sim
    super
    aging delay
    area = think
  end

  def calculate step
    eat(step)
  end

  def eat step
    self.health += (food_eaten - needed_food) * step
    self.health = max_health if health > max_health
    die! if health <= 0
  end

  def aging step
    self.next_birth += step
    self.age += step
    die! if age >= age_death
    reproduce if next_birth >= birth_step
  end

  def food_eaten
    field.vegetation.sim
    food_available = field.vegetation.size
    # food_eaten = x * r * (max_food - x) / max_food
    # TODO smart formula
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
    raise Death
  end

  def reproduce
    self.next_birth -= birth_step
    # TODO fire reproduce event
    # child = self.class.build
    # fire DropEvent.new(child)
  end

  def create_event
    Event::Bot.new(self)
  end

end
