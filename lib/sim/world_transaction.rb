# all manipulation on the world should be done through
# this actor. Like this only one thread accesses the
# world and keeps it consistent.
class WorldTransaction
  include Celluloid
  include Celluloid::Logger

  def attr_reader :world

  def initialize world
    @world = world
  end

  def move property, source, target
    object = delete(source, property)
    add(target, property, object)
  end

  def delete field, propery
    field.delete property
  end

  def add field, property, object
    field.merge!(property => object)
  end

  def change field, property, attribute, value
    field.property.send("#{attribute}=", value)
  end

  def transaction
    yield
  end

end

# include in sim objects
module TransActions
  extend Forwardable

  def_delegators :@world_transaction, :move, :delete, :add

  def world_transaction
    @world_transaction = Celluloid::Actor[:world_transaction]
  end

  def transaction
    world_transaction.transaction { yield }
  end

end
