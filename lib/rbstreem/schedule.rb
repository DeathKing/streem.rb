class Component
  # instead of using a event loop, we use some of schedule
  # algorithm to switch between each component, to avoid
  # we stay in a data-flow too long.
  def self.start
    until @@tasks.empty?
      ready_queue = @@tasks.select(&:ready?)
      ready_queue.each do |com|
        # the run process should not run to long and yield
        # after it is over
        com.run
        @@tasks.delete(com) if com.dead?
      end
    end
  end
end

at_exit {Component.start}