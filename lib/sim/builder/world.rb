module Builder

  class World

    def initialize world
      @world = world
      srand
    end

    def create config
      start_time = Time.now

      create_vegetation config[:vegetation] if config[:vegetation]
      create_flora config[:flora] if config[:flora]
      create_fauna config[:fauna] if config[:fauna]

      $stderr.puts "world created after #{Time.now - start_time}"
      @world
    end

    # --- create vegetation ---

    def create_vegetation config
      file = File.join(__dir__, '..', '..', '..', 'config', 'levels', config[:config])
      @vegetation_config = Sim::Buildable.load_config(file)
      grounding config[:grounding]
      config[:clusters].each do |cluster_config|
        draw_clusters cluster_config[:times], cluster_config[:vegetation], cluster_config[:count]
      end
      # FIXME remove
      border

      add_objects_to_sim_loop
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
      Vegetation.build(config)
    end

    def add_objects_to_sim_loop
      @world.each_field do |field|
        field.vegetation.queue_up
      end
    end

    # --- create flora and fauna ---

    def create_flora config
      create_flora_fauna(config) do |field, type|
        field.flora = type
      end
    end

    def create_fauna config
      create_flora_fauna(config) do |field, type|
        field.fauna = type
      end
    end

    def create_flora_fauna config
      spread_ratio = @world.height * @world.width / config[:per_fields].to_f
      config[:types].each do |type_config|
        type = type_config[:type]
        type_config[:spread].each do |spread|
          fields = @world.find_all {|field| field[:vegetation].view_value == spread[:vegetation] && field[:flora].nil? }
          size = (spread[:amount] * spread_ratio).round
          fields.shuffle.slice(0, size).each do |field|
            yield field, type
          end
        end
      end
    end

  end

end
