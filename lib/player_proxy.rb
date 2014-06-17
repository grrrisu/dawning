class PlayerProxy

  attr_accessor :id

  def initialize
    @id = UUID.new.generate
  end

end
