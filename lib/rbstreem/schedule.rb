module RbStreem
  class Component

    class << self
      # instead of using a event loop, we use some of schedule
      # algorithm to switch between each component, to avoid
      # the situation that we stay in a data-flow too long.
      def start_schedule
        remove_broken_pipe
        remove_dead_component
        until task_queue.empty?
          ready_queue = task_queue.select(&:ready?)
          capacity = ready_queue.length + 1
          schedule_queue = ready_queue.sample rand(capacity)
          schedule_queue.each do |component|
            # FIXME: some preemptive schedule algorithm support here
            # the run method should not run too long and must yield
            # after it is done
            begin
              component.run
            rescue => e
              puts "Error while run #{component}"
              puts e.message
            end
          end

          remove_broken_pipe if should_clean_pipe?
          remove_dead_component if should_clean_component?
        end
      end

      def should_clean_pipe?
        rand(100) < 15
      end

      def should_clean_component?
        rand(100) < 20
      end

    end
  end
end
