class LevelProxy

  def self.create name
    @levels ||= {}
    @uuid   ||= UUID.new
    unless @levels[name]
      id = @uuid.generate
      @levels[id] = new(id, name)
      @levels[id].launch
    else
      raise ArgumentError, "level with name [#{name}] already exists!"
    end
  end

  def self.levels
    @levels.try(:values) || []
  end

  def self.find id
    @levels[id] or raise ArgumentError, "level with id #{id} not found!"
  end

  def self.delete id
    @levels.delete id
  end

  attr_reader :id, :name, :state

  def initialize id, name
    @id         = id
    @name       = name
    @connection = Sim::Popen::ParentConnection.new
  end

  def action action, params
    @connection.send_action action, params
  end

  def player_action player_id, action, params
    @connection.send_player_action player_id, action, params
  end

  def launch
    sim_library = Rails.root.join('lib', 'sim', 'level.rb')
    level_class = 'Level'
    @connection.launch_subprocess(sim_library, level_class)
    @state = :launched
    self
  end

  def build config
    if @state == :launched
      config_file = Rails.root.join('config', 'levels', config).to_s
      @connection.send_action :build, config_file: config_file
      @state = :ready
    else
      raise ArgumentError, "level must be in state started but is in '#{@state}'"
    end
  end

  def start
    if @state == :ready
      @connection.send_action :start
      @state = :running
    else
      raise ArgumentError, "level must be in state built but is in '#{@state}'"
    end
  end

  def stop
    if @state == :running
      @connection.send_action :stop
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
