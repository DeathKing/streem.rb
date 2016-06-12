require 'pp'

module RbStreem
  class Component
    # instead of using a event loop, we use some of schedule
    # algorithm to switch between each component, to avoid
    # the situation that we stay in a data-flow too long.
    def self.start_schedule
      STDIN.write_pipes.empty? && task_queue.delete(STDIN)
      until task_queue.empty?
        #inspect_task_queue
        ready_queue = task_queue.select(&:ready?)
        capacity = ready_queue.length + 1
        schedule_queue = ready_queue.sample(rand(capacity))
        schedule_queue.each do |component|
          # FIXME: some preemptive schedule algorithm support here
          # the run method should not run too long and must yield
          # after it is done
          component.run
          component.dead? && task_queue.delete(component)
        end
      end
    end

    def self.inspect_task_queue
      puts "=" * 20
      task_queue.each {|t| print "#{t.name} -->"}
      puts ""
      puts "=" * 20
    end

  end
end
