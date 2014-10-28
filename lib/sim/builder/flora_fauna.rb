module Builder

  class FloraFauna

    attr_reader :config

    def initialize world
      @world = world
    end

    def load_type_config
      file = File.join(__dir__, '..', '..', '..', 'config', 'levels', config[:config])
      @type_config = Sim::Buildable.load_config(file)
    end

    def create config
      @config = config
      load_type_config
    end

    def create_flora config
      create config
      set_flora
    end

    def create_fauna config
      #create config
      set_fauna
    end

    def set_flora
      create_flora_fauna do |field, type|
        flora = build_flora(type)
        field.flora, flora.field = flora, field
      end
    end

    def build_flora type
      flora_config = @type_config[type.to_sym]
      ::Flora.build(flora_config)
    end

    def set_fauna
      create_flora_fauna do |field, type|
        field.fauna = type
      end
    end

    def create_flora_fauna
      spread_ratio = @world.height * @world.width / config[:per_fields].to_f
      config[:types].each do |type_config|
        type = type_config[:type]
        type_config[:spread].each do |spread|
          fields = @world.find_all {|field| field[:vegetation].type == spread[:vegetation] && field[:flora].nil? }
          size = (spread[:amount] * spread_ratio).round
          fields.shuffle.slice(0, size).each do |field|
            yield field, type
          end
        end
      end
    end

  end

end
