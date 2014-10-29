module Builder

  class Vegetation

    attr_reader :config

    def initialize world
      @world = world
    end

    def load_configuration file_name
      file = File.join(__dir__, '..', '..', '..', 'config', 'levels', file_name)
      Sim::Buildable.load_config(file)
    end

    def create config
      @config = load_configuration config[:builder]
      @vegetation_config = load_configuration config[:classes]
      create_vegetation
    end

    def create_vegetation
      grounding config[:grounding]
      config[:clusters].each do |cluster_config|
        draw_clusters cluster_config[:times], cluster_config[:vegetation], cluster_config[:count]
      end
      # FIXME remove
      border
    end

    def border
      @world.width.times do |i|
        set_vegetation(i, 0, 0)
        set_vegetation(i, @world.height-1, 0)
      end

      @world.height.times do |i|
        set_vegetation(0, i, 0)
        set_vegetation(@world.width-1, i, 0)
      end
    end

    def grounding grounding
      @world.each_field do |field|
        set_vegetation(field.x, field.y, grounding)
      end
    end

    def draw_clusters number, vegetation, count
      number.times do
        x, y = rand(@world.width), rand(@world.height)
        draw_cluster x, y, vegetation, {count: count}
      end
    end

    def draw_cluster x, y, property, options = {}
      cx, cy = x, y
      stop_count = options[:count] || 5
      count = 0

      begin
        cx, cy = cx + rand(3) -1, cy + rand(3) -1
        unless @world[cx, cy].vegetation.try(:view_value) == property
          count += 1
          set_vegetation(cx, cy, property)
        end
      end until count == stop_count
    end

    def set_vegetation x, y, type
      vegetation = build_vegetation(type)
      @world[x, y].vegetation = vegetation
      vegetation.field = @world[x, y]
    end

    def build_vegetation type
      config = @vegetation_config[type]
      ::Vegetation.build(config)
    end

  end

end
