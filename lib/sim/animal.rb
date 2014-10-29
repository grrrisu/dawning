class Animal < Sim::Object

  default_attr :age, 0
  default_attr :age_death, 30
  default_attr :health, 50
  defautl_attr :max_health, 100
  default_attr :birth_step, 5
  default_attr :next_birth, 0
  default_attr :needed_food, 20
  default_attr :max_food, 30

  attr_accessor :field

  def sim
    area = super
    aging delay
    think
    area
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
    # TODO smart formula
  end

  def think
    look_around
    move
  end

  def die!
    raise Death
  end

  def reproduce
    self.next_birth -= birth_step
    # TODO fire reproduce event
  end

  def create_event
    Event::Bot.new(self)
  end

end
