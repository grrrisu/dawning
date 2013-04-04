class WorldBuilder

  def initialize world
    @world = world
    srand
  end

  def create options = {}
    start_time = Time.now
    grounding
    draw_clusters
    $stderr.puts "world created after #{Time.now - start_time}"
    @world
  end

  def grounding
     @world.set_each_field do |field|
      {vegetation: 5}
    end
  end

  def draw_clusters
    10.times do
      x, y = rand(@world.width), rand(@world.height)
      draw_cluster x, y, {vegetation: 2}, {count: 10}
    end
    20.times do
      x, y = rand(@world.width), rand(@world.height)
      draw_cluster x, y, {vegetation: 3}, {count: 30}
    end
    50.times do
      x, y = rand(@world.width), rand(@world.height)
      draw_cluster x, y, {vegetation: 8}, {count: 80}
      draw_cluster x, y, {vegetation: 13}, {count: 40}
    end
  end

  def draw_cluster x, y, property, options = {}
    cx, cy = x, y
    stop_count = options[:count] || 5
    count = 0

    #puts "x y #{x} #{y}"
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
    #puts 'end draw cluster'
  end

end
