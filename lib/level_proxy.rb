class LevelProxy

  def self.create name
    @uuid ||= UUID.new
    unless level_by_name(name)
      id = @uuid.generate
      level = new(id, name)
      add_level id, level
      level.launch
      level
    else
      raise ArgumentError, "level with name [#{name}] already exists!"
    end
  end

  def self.level_by_name name
    @levels ||= {}
    @levels.find {|id, level| level.name == name }
  end


  def self.add_level id, level
    @levels ||= {}
    @levels[id] = level
  end

  def self.levels
    @levels.try(:values) || []
  end

  def self.active
    levels.reject {|level| [:launched, :destroyed].include? level.state}
  end

  def self.find id
    if @levels
      @levels[id] or raise ArgumentError, "level with id #{id} not found!"
    end
  end

  def self.delete id
    @levels.delete id
  end

  # --- Instance Methods ----

  attr_reader :id, :name, :state, :players, :connection, :config_file

  def initialize id, name
    @id         = id
    @name       = name
    @connection = Sim::Net::ParentConnection.new
    @players    = {}    # maps user_id to player_proxy
  end

  # --- players ---

  def add_player user_id, options = {}
    unless find_player(user_id)
      player = PlayerProxy.new options
      @players[user_id] = player
    else
      raise ArgumentError, "user [#{user_id}] has already been added to this level [#{id}]"
    end
  end

  def remove_player user_id
    if player = find_player(user_id)
      @connection.send_action :remove_player, id: player.id
    end
  end

  def find_player user_id
    @players[user_id]
  end

  def action action, params = nil
    Rails.logger.debug "send action #{action} with #{params.inspect}"
    @connection.send_action action, params
  rescue Errno::EPIPE
    Rails.logger.error "level [#{id}] is corrupt -> removing"
    LevelProxy.delete id
  end

  # --- states ---

  def launch
    sim_library = Rails.root.join('lib', 'sim', 'level.rb')
    level_class = 'Level'
    @connection.launch_subprocess(sim_library, level_class, Rails.root.join('config', 'level.yml').to_s, Rails.env)
    @state = :launched
    self
  end

  def build config
    if @state == :launched
      @config_file = config
      file = Rails.root.join('config', 'levels', config).to_s
      @connection.send_action :build, config_file: file
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
    if %i{launched ready running}.include? @state
      @connection.send_action :stop
      @state = :stopped
    else
      raise ArgumentError, "level must be in state launched, ready or running but is in '#{@state}'"
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

  def as_json
    json = { id: id, name: name, state: state, config_file: config_file }
    unless state == :stopped
      json.merge! @connection.send_action :as_json
    end
    json
  end

  def objects_count
    unless state == :stopped
      @connection.send_action :objects_count
    end
  end

  def terminal_command command
    @connection.send_action :terminal_command, command: command
  end

end
