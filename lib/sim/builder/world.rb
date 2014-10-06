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
      grounding config[:grounding]
      config[:clusters].each do |cluster_config|
        draw_clusters cluster_config[:times], cluster_config[:vegetation], cluster_config[:count]
      end
      # FIXME remove
      border
    end

    def border
      @world.width.times do |i|
        @world[i,0].vegetation = build_vegetation(0)
        @world[i,@world.height-1].vegetation = build_vegetation(0)
      end

      @world.height.times do |i|
        @world[0,i].vegetation = build_vegetation(0)
        @world[@world.width-1, i].vegetation = build_vegetation(0)
      end
    end

    def grounding grounding
      @world.each_field do |field|
        field.vegetation = build_vegetation(grounding)
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
          @world[cx, cy].vegetation = build_vegetation(property)
        end
      end until count == stop_count
    end

    def build_vegetation property
      Vegetation.build(Vegetation::TYPE[property])
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
          fields = @world.find_all {|field| field[:vegetation] == spread[:vegetation] && field[:flora].nil? }
          size = (spread[:amount] * spread_ratio).round
          fields.shuffle.slice(0, size).each do |field|
            yield field, type
          end
        end
      end
    end

  end

end
