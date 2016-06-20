module RbStreem
  class Component
    # instead of using a event loop, we use some of schedule
    # algorithm to switch between each component, to avoid
    # the situation that we stay in a data-flow too long.
    def self.start_schedule
      ready_queue.each {|c| remove_component(c) if c.dead?}
      until task_queue.empty?
        ready_queue = task_queue.select(&:ready?)
        capacity = ready_queue.length + 1
        schedule_queue = ready_queue.sample rand(capacity)
        schedule_queue.each do |component|
          # FIXME: some preemptive schedule algorithm support here
          # the run method should not run too long and must yield
          # after it is done
          component.run
          component.dead? && remove_component(component)
        end
      end
    end

    def self.remove_component(comp)
      # TODO: make pipes connected to comp broken.
      task_queue.delete(comp)
    end

  end
end
