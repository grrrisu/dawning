class Animal

  default_attr :age, 0
  default_attr :age_treshold, 30
  default_attr :hunger, 50
  default_attr :reproduce_treshold, 100
  default_attr :needed_food, 20

  attr_accessor :field

  def calculate step
    aging(step)
    eat(step)
  end

  def aging step
    self.age += step
    die! if age >= age_treshold
  end

  def eat step
    self.hunger += food_eaten - needed_food
    if hunger <= 0
      die!
    elsif hunger >= reproduce_treshold
      reproduce
    end
  end

  def food_eaten

  end

  def think
    look_around
    move
  end

  def die!
    raise Death
  end

  def reproduce
  end

  def create_event
    Event::Bot.new(self)
  end

end
