class Component
  def self.start
    until @@tasks.empty?
      ready_queue = @@tasks.select {|t| t.ready?}
      ready_queue.each do |com|
        com.run
        @@tasks.delete com if com.dead?
      end
    end
  end
end

at_exit {Component.start}