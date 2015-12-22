module Builder

  class Dungeon

    attr_accessor :dungeon
    attr_reader :config

    def initialize config
      @config = config
    end

    def create
      # TODO a superivsor should do that
      self.dungeon = ::Dungeon::Actor.new
      load_data @config[:data_file]
      dungeon
    end

    def load_data file_name
      path = File.join(__dir__, '..', '..', '..', 'config', 'levels', file_name)
      data = JSON.load(File.open(path))
      dungeon.map.matrix = data['fields']
    end

  end

end
