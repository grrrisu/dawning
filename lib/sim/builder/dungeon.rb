module Builder

  class Dungeon

    attr_accessor :dungeon
    attr_reader :config

    def initialize config
      @config = config
    end

    def create
      self.dungeon = ::Dungeon.new
      load_data @config[:data_file]
      dungeon
    end

    def load_data file_name
      path = File.join(__dir__, '..', '..', '..', 'config', 'levels', 'dungeons', file_name)
      data = JSON.load(File.open(path))
      dungeon.matrix = data['fields']
    end

  end

end
