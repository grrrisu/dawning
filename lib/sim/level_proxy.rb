class LevelProxy

  def self.create name
    @levels ||= {}
    unless @levels[name]
      @levels[name] = new(name)
    else
      raise ArgumentError, "level with name [#{name}] already exists!"
    end
  end

  def self.levels
    @levels.try(:values) || []
  end

  attr_reader :name

  def initialize name
    @name       = name
    @connection = Sim::Popen::ParentConnection.new
    sim_library = Rails.root.join('lib', 'sim', 'level.rb')
    level_class = 'Level'
    config_file = Rails.root.join('config', 'level.yml')

    ruby = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    cmd = %W{#{ruby} -r #{sim_library} -e #{level_class}.attach #{config_file}}
    puts "***** #{cmd}"

    @connection.start(sim_library, level_class, config_file)
  end

end
