module RbStreem
  class Component
    # instead of using a event loop, we use some of schedule
    # algorithm to switch between each component, to avoid
    # we stay in a data-flow too long.
    def self.start_schedule
      STDIN.write_pipes.empty? && @@tasks.delete(STDIN)
      #STDOUT.read_pipes.empty? && @@task.delete(STDOUT)
      until @@tasks.empty?
        ready_queue = @@tasks.select(&:ready?)
        ready_queue.each do |component|
          # FIXME: some preemptive schedule algorithm support here
          # the run method should not run too long and must yield
          # after it is done
          component.run
          #component.dead? && @@tasks.delete(component)
        end
      end
    end
  end
end
