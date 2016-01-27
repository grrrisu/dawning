module Builder

  class Dungeon

    attr_accessor :dungeon
    attr_reader :config

    def initialize config
      @config = config
      @uuid   = UUID.new
    end

    def create
      # TODO a superivsor should do that
      self.dungeon = ::Dungeon::Actor.new
      load_data @config[:data_file]
      dungeon
    end

    def load_data file_name
      path = File.join(__dir__, '..', '..', '..', 'config', 'levels', file_name)
      data = JSON.load File.open(path)
      dungeon.map  = create_map data['fields']
    end

    def create_map data
      map = ::Dungeon::Map.new(data.size)
      populate_map map, data
      map
    end

    def populate_map map, data
      map.each_field_with_index do |field, x, y|
        if thing = create_thing(data, x, y)
          field.push(thing)
        end
      end
    end

    def create_thing data, x, y
      field_data = data[y][x]
      case field_data
      when 'X' then ::Dungeon::Tree.build
      when 'x' then ::Dungeon::Tree.build blocks_visability: false
      when '1' then ::Dungeon::Fruit.build capacity: ::Dungeon::Fruit::Banana1
      when '2' then ::Dungeon::Fruit.build capacity: ::Dungeon::Fruit::Banana2
      when '3' then ::Dungeon::Fruit.build capacity: ::Dungeon::Fruit::Banana3
      when 'R' then ::Dungeon::Rabbit.build x: x, y: y
      when 'L' then create_leopard x, y
      when 'H' then ::Dungeon::Headquarter.build
      end
    end

    def create_leopard x, y
      leopard = ::Dungeon::Leopard.build x: x, y: y
      leopard.uuid = @uuid.generate
      dungeon.animals[leopard.uuid] = leopard
      leopard
    end

  end

end
