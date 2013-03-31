class LevelProxy

  def self.create name
    @levels ||= {}
    @uuid   ||= UUID.new
    unless @levels[name]
      id = @uuid.generate
      @levels[id] = new(id, name)
    else
      raise ArgumentError, "level with name [#{name}] already exists!"
    end
  end

  def self.levels
    @levels.try(:values) || []
  end

  def self.find id
    @levels[id]
  end

  def self.delete id
    @levels.delete id
  end

  attr_reader :id, :name, :state

  def initialize id, name
    @id         = id
    @name       = name
    @connection = Sim::Popen::ParentConnection.new
    sim_library = Rails.root.join('lib', 'sim', 'level.rb')
    level_class = 'Level'
    config_file = Rails.root.join('config', 'level.yml')
    @connection.start(sim_library, level_class, config_file)
    @state = :started
  end

  def create
    if @state == :started
      @connection.send_message action: 'create', params: 'path/to/level.yml'
      @state = :built
    else
      raise ArgumentError, "level must be in state started but is in '#{@state}'"
    end
  end

  def start
    if @state == :built
      @connection.send_message action: 'start'
      @state = :running
    else
      raise ArgumentError, "level must be in state built but is in '#{@state}'"
    end
  end

  def stop
    if @state == :running
      @connection.send_message action: 'stop'
      @state = :stopped
    else
      raise ArgumentError, "level must be in state running but is in '#{@state}'"
    end
  end

  def remove
    if @state == :stopped
      LevelProxy.delete @id
      @state = :destroyed
    else
      raise ArgumentError, "level must be in state stopped but is in '#{@state}'"
    end
  end

end
