module Builder

  class World

    def initialize world
      @world = world
      @vegetation_builder = Vegetation.new(@world)
      @flora_fauna_buidler = FloraFauna.new(@world)
      srand
    end

    def create config
      start_time = Time.now

      @vegetation_builder.create config[:vegetation] if config[:vegetation]
      @flora_fauna_buidler.create_flora config[:flora] if config[:flora]
      @flora_fauna_buidler.create_fauna config[:fauna] if config[:fauna]

      add_objects_to_sim_loop
      $stderr.puts "world created after #{Time.now - start_time}"
      @world
    end

    def add_objects_to_sim_loop
      @world.each_field do |field|
        field.vegetation.queue_up
        field.flora.try(:queue_up)
      end
    end

  end

end
