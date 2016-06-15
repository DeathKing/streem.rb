module RbStreem
  class Component

    include Connectable

    # This is schedule queue
    @@tasks = []

    attr_reader :read_pipes
    attr_reader :write_pipes


    def initialize(agent)
      # Contract Checks
      # Agent is the actuall code to be excuted when a component running. An
      # agent must implement following interfaces:
      #   + call() with single argument, this is used when a component been run()
      #   + dead?() with no argument, this is used in schedule algorithm to
      #     to determine whether a component has already been excuted and have to
      #     move it out
      #   + ready?() with no argument, this is used to determine the agent is
      #     ready to run
      #   + producer?() with no argument, this is used to determine whether a
      #     component could yield some computation result
      #   + customer?() with no arugment, this is used to determine whether a
      #     component depend on data from up-stream
      %w{call dead? ready? producer? customer?}.each do |method|
        unless agent.respond_to? method
          raise "Agent must implement #{method} method."
        end
      end

      @agent = agent
      @read_pipes = {}
      @write_pipes = {}

      add_to_task_queue(self)
    end

    def name
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    def connection_target
      self
    end

    def connection_source
      self
    end

    # This method been called if only if the component is ready and been select
    # out by the scheduler.
    def run
      # FIXME: Take a sample may not be a good schedule algorithm.
      read_pipe = ready_read_pipes.sample
      if read_pipe.nil?
        result = @agent.call(nil)
        boradcast(result) unless result.is_a?(SkipClass)
      else
        write_pipe = @write_pipes[read_pipe.flow_tag]
        result = @agent.call(read_pipe.gets)
        write_pipe.puts(result) unless write_pipe.nil? || result.is_a?(SkipClass)
      end
      result
    rescue => e
      puts "Error while run #{name}."
      puts read_pipes.inspect
      puts write_pipes.inspect
      puts @agent.inspect
      puts e.message
    end

    def broadcast(value)
      @write_pipes.each_value { |p| p.puts(value) }
    end

    # ready?, blocked? and dead? should be refactored

    def ready?
      # no read_pipes means the component is a producer, it's ready only depend
      # on the agent's state
      if @read_pipes.empty?
        @agent.producer?
      else
        @agent.ready? && !ready_read_pipes.empty?
      end
    end

    # In this version, it seems that blocked? has no sense, I just put it here to
    # make streem.rb more like a OS, maybe.
    def blocked?
      if @read_pipes.empty?
        @agent.blocked?
      else
        @agent.blocked? && ready_read_pipes.empty?
      end
    end

    # if @agent is dead, the component must be dead, and should be
    # moved out from the schedule.
    # if @agent wait for some input but there's no such read pipe
    # that available, then it goes to dead.
    def dead?
      @agent.dead? ||
        (!@agent.producer? && avaliable_read_pipes.empty?)
    end

    def ready_read_pipes
      @read_pipes.each_value.select { |p| p.ready? }
    end

    def avaliable_read_pipes
      @read_pipes.each_value.reject { |p| p.broken? }
    end

    def add_read_pipe(pipe)
      @read_pipes[pipe.flow_tag] = pipe
    end

    def add_write_pipe(pipe)
      @write_pipes[pipe.flow_tag] = pipe
    end

    def remove_read_pipe(name)
      @read_pipes.delete(name)
    end

    def remove_write_pipe(name)
      @write_pipes.delete(name)
    end

    def remove_pipe(name)
      remove_read_pipe(name)
      remove_write_pipe(name)
    end

    def self.task_queue
      @@tasks
    end

    def task_queue
      @@tasks
    end

    def add_to_task_queue(comp)
      @@tasks << comp
    end

  end
end
