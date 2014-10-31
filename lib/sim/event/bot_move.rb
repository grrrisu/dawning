module Event
  class BotMove < Sim::Queue::SimEvent

    def self.move_resources world, center
      @resources ||= Array.new.tap do |fields|
        View.square(1) do |i, j|
          fields << world[center.x + i, center.y + j].coordinates
        end
      end
    end

    def needed_resources
      BotMove.move_resources(object.world, object)
    end

  end
end
