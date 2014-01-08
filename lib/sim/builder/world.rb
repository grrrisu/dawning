module Builder

  class World

    def initialize world
      @world = world
      srand
    end

    def create config
      start_time = Time.now

      create_vegetation config['vegetation']
      create_flora config['flora']
      create_fauna config['fauna']

      $stderr.puts "world created after #{Time.now - start_time}"
      @world
    end

    # --- create vegetation ---

    def create_vegetation config
      grounding config['grounding']
      config['clusters'].each do |cluster_config|
        draw_clusters cluster_config['times'], cluster_config['vegetation'], cluster_config['count']
      end
      # FIXME remove
      border
    end

    def border
      @world.width.times do |i|
        @world[i,0] = {vegetation: 1}
        @world[i,@world.height-1] = {vegetation: 0}
      end

      @world.height.times do |i|
        @world[0,i] = {vegetation: 1}
        @world[@world.width-1, i] = {vegetation: 0}
      end
    end

    def grounding grounding
      @world.set_each_field do |field|
        {vegetation: grounding}
      end
    end

    def draw_clusters number, vegetation, count
      number.times do
        x, y = rand(@world.width), rand(@world.height)
        draw_cluster x, y, {vegetation: vegetation}, {count: count}
      end
    end

    def draw_cluster x, y, property, options = {}
      cx, cy = x, y
      stop_count = options[:count] || 5
      count = 0

      begin
        cx, cy = cx + rand(3) -1, cy + rand(3) -1

        cx = @world.width() -1 if cx < 0
        cy = @world.height() -1 if cy < 0
        cx = 0 if cx >= @world.width
        cy = 0 if cy >= @world.height
        #puts "move   #{cx} #{cy}"
        count += 1 unless @world[cx, cy] == property

        @world[cx, cy] = property

      end until count == stop_count
    end

    # --- create flora and fauna ---

    def create_flora config
      create_flora_fauna(config) do |field, type|
        field.merge! flora: type
      end
    end

    def create_fauna config
      create_flora_fauna(config) do |field, type|
        field.merge! fauna: type
      end
    end

    def create_flora_fauna config
      $stderr.puts config.inspect
      per_fields = config['per_fields']
      config['types'].each do |type_config|
        type = type_config['type']
        type_config['spread'].each do |spread|
          fields = @world.find_all {|field| field[:vegetation] == spread['vegetation'] && field[:flora].nil? }
          raise "spread amount #{spread['amount']} is bigger than available fields #{fields.size}" if spread['amount'] > fields.size
          size = spread['amount'] * fields.size / per_fields
          $stderr.puts type, fields.size, size
          fields.shuffle.slice(0, size).each do |field|
            yield field, type
          end
        end
      end
    end

  end

end
