module Event
  class SimField < Sim::Queue::SimEvent

    def needed_resources
      [object.field]
    end

  end
end
