module Builder

  class World

    def initialize world
      @world = world
      @vegetation_builder  = Builder::Vegetation.new(@world)
      @flora_fauna_buidler = Builder::FloraFauna.new(@world)
      srand
    end

    def create config
      start_time = Time.now

      @vegetation_builder.create config[:vegetation] if config[:vegetation]
      @flora_fauna_buidler.create_flora ::Flora, config[:flora] if config[:flora]
      @flora_fauna_buidler.create_fauna ::Animal, config[:fauna] if config[:fauna]

      add_objects_to_sim_loop
      puts "world created after #{Time.now - start_time}"
      @world
    end

    def add_objects_to_sim_loop
      @world.each_field do |field|
        field.vegetation.try(:queue_up)
        field.flora.try(:queue_up)
        field.fauna.try(:queue_up)
      end
    end

  end

end
