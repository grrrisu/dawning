module Event
  class BotMove < Sim::Queue::SimEvent

    def self.move_resources world, center
      Array.new.tap do |fields|
        View.square(1) do |i, j|
          fields << world[center.x + i, center.y + j].coordinates
        end
      end
    end

    def needed_resources
      @resources ||= BotMove.move_resources(object.world, object.field)
    end

    def fire
      changed_area = object.update_simulation
    rescue Death => d
      changed_area = d.changed_area
    ensure
      notify(changed_area)
    end

  end
end
