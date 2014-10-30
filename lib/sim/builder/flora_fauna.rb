module Builder

  class FloraFauna

    attr_reader :config, :namespace

    def initialize world, namespace
      @world = world
    end

    def load_configuration file_name
      file = File.join(__dir__, '..', '..', '..', 'config', 'levels', file_name)
      Sim::Buildable.load_config(file)
    end

    def create namspace, config
      @namespace = namespace
      @config = load_configuration config[:builder]
      @type_config = load_configuration config[:classes]
      create_classes
    end

    def create_classes
      @type_config.each do |klass_name, config|
        unless namespace.const_defined?(klass_name)
          namespace.const_set(klass_name, Class.new(namespace))
          namespace.const_get(klass_name).set_defaults(config)
        end
      end
    end

    def create_flora namspace, config
      create namspace, config
      set_field :flora
    end

    def create_fauna namspace, config
      create namspace, config
      set_field :fauna
    end

    def set_field property
      create_flora_fauna do |field, type|
        object = build_object(type)
        field.send(property), object.field = object, field
      end
    end

    def build_object klass
      namespace.const_get(klass).build
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
