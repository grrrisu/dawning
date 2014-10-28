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

    def create_classes
      @type_config.each do |klass_name, config|
        unless ::Vegetation.const_defined?(klass_name)
          ::Vegetation.const_set(klass_name, Class.new(::Vegetation))
          ::Vegetation.const_get(klass_name).set_defaults(config)
        end
      end
    end

    def create config
      @config = config
      load_type_config
    end

    def create_flora config
      create config
      create_classes
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

    def build_flora klass
      ::Vegetation.const_get(klass).build
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
          fields = free_fields_of_vegetation spread[:vegetation]
          size = (spread[:amount] * spread_ratio).round
          fields.shuffle.slice(0, size).each do |field|
            yield field, type
          end
        end
      end
    end

    def free_fields_of_vegetation vegetation_type
      @world.find_all do |field|
        field[:vegetation].type == vegetation_type && field[:flora].nil?
      end
    end

  end

end
