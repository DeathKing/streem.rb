module RbStreem
  class Component

    class << self
      # instead of using a event loop, we use some of schedule
      # algorithm to switch between each component, to avoid
      # the situation that we stay in a data-flow too long.
      def start_schedule
        task_queue.each {|c| c.remove_out if c.dead?}
        remove_broken_pipe
        until task_queue.empty?
          remove_broken_pipe if should_clean_pipe?
          ready_queue = task_queue.select(&:ready?)
          capacity = ready_queue.length + 1
          schedule_queue = ready_queue.sample rand(capacity)
          schedule_queue.each do |component|
            # FIXME: some preemptive schedule algorithm support here
            # the run method should not run too long and must yield
            # after it is done
            begin
              component.run
              component.dead? && component.remove_out
            rescue => e
              puts "Error while run #{component}."
              puts e.message
            end
          end
        end
      end

      def should_clean_pipe?
        rand(100) < 15
      end

    end
  end
end
