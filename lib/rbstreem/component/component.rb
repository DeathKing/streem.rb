module RbStreem
  class Component

    include Connectable

    class << self

      # This is schedule queue
      @tasks = []

      def task_queue
        @tasks
      end

      def add_to_task_queue(comp)
        @tasks << comp
      end
    end

    attr_reader :read_pipes
    attr_reader :write_pipes


    def initialize(agent)
      # Contract Checks
      # Agent is the actual code to be executed when a component running. An
      # agent must implement following interfaces:
      #   + call() with single argument, this is used when a component been run()
      #   + dead?() with no argument, this is used in schedule algorithm to
      #     to determine whether a component has already been executed and have to
      #     move it out
      #   + ready?() with no argument, this is used to determine the agent is
      #     ready to run
      #   + producer?() with no argument, this is used to determine whether a
      #     component could yield some computation result
      %w{call dead? ready? producer?}.each do |method|
        unless agent.respond_to? method
          raise "Agent must implement #{method} method."
        end
      end

      @agent = agent
      @read_pipes = []
      @write_pipes = []

      self.class.add_to_task_queue(self)
    end

    def finalize

    end

    def name
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    def check_connection_target_type(_)
      true
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
      flow_tag = read_pipe && read_pipe.flow_tag
      input = read_pipe && read_pipe.gets
      result = @agent.call(input)
      boradcast(result, flow_tag) unless result.is_a?(SkipClass)
      result
    rescue => e
      puts "Error while run #{name}."
      puts read_pipes.inspect
      puts write_pipes.inspect
      puts @agent.inspect
      puts e.message
    end

    def broadcast(value, flow_tag=nil)

      write_pipes = if flow_tag
        @write_pipes.select {|p| p.flow_tag == flow_tag}
      else
        @write_pipes
      end

      write_pipes.each {|p| p.puts(value)}
    end

    # ready?, blocked? and dead? should be refactored

    def ready?
      # no read_pipes means the component is a producer, it's ready only depend
      # on the agent's state
      @agent.ready? &&
          (@read_pipes.empty? ? @agent.producer? : !ready_read_pipes.empty?)
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
      @read_pipes.select {|p| p.ready?}
    end

    def avaliable_read_pipes
      @read_pipes.reject {|p| p.broken?}
    end

    def add_read_pipe(pipe)
      @read_pipes << pipe
    end

    def add_write_pipe(pipe)
      @write_pipes << pipe
    end

    def remove_read_pipe(flow_tag)
      @read_pipes.delete_if {|p| p.flow_tag == flow_tag}
    end

    def remove_write_pipe(flow_tag)
      @write_pipes.delete_if {|p| p.flow_tag == flow_tag}
    end

    def remove_pipe(flow_tag)
      remove_read_pipe(flow_tag)
      remove_write_pipe(flow_tag)
    end

  end
end
