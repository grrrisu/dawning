class LevelManager
  include Singleton

  def create name
    @uuid ||= UUID.new
    unless level_by_name(name)
      id = @uuid.generate
      level = LevelProxy.new(id, name)
      add_level id, level
      level.launch
      level
    else
      raise ArgumentError, "level with name [#{name}] already exists!"
    end
  end

  def level_by_name name
    @levels ||= {}
    @levels.find {|id, level| level.name == name }
  end


  def add_level id, level
    @levels ||= {}
    @levels[id] = level
  end

  def levels
    @levels.try(:values) || []
  end

  def actives
    levels.reject {|level| [:launched, :destroyed].include? level.state}
  end

  def find id
    @levels && @levels[id]
  end

  def delete id
    @levels.delete id
  end

end
