class Component

  include Connectable

  # This is schedule queue
  @@tasks = []

  attr_reader :read_pipes
  attr_reader :write_pipes

  def initialize(agent)
    # Constrain Checks
    # Agent must implement following protocol:
    #   + call() with single argument, this is used when a component been run()
    #   + dead?() with no argument, this is used in schedule algorithm to
    #     to determine whether a component has already been excuted and have to
    #     move it out
    raise "Agent must respond to call method" unless agent.respond_to? :call
    raise "Agent must respond to dead? method" unless agent.respond_to? :dead?
    @agent = agent
    @read_pipes = {}
    @write_pipes = {}
    # Add self to sechdule queue
    @@tasks << self
  end

  def name
    "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
  end

  def inspect
    header = "#{name}\n"

    pipe_for_read = "Pipes for read ----------------------------------------------\n"
    @read_pipes.each_value do |p|
      pipe_for_read << sprintf("%18s %10s %20s\n", p.name, p.head.inspect, p.customer.name)
    end
    pipe_for_write = "Pipes for write ---------------------------------------------\n"
    @write_pipes.each_value do |p|
      pipe_for_write << sprintf("%18s %10s %20s\n", p.name, p.head.inspect, p.customer.name)
    end

    header + pipe_for_read + pipe_for_write
  end

  def |(target)
    if target.is_a?(Pipe)
      # if a component is going to connenct to a pipe, that must be this
      # situation:
      #    +------------------------------------------+
      #    | com1.| A.| B   =====>   (com1.| (A.| B)) |
      #    +------------------------------------------+
      # cause whatever A and B (of course, the must respond_to the | method),
      # `A.| B` always returns a pipe, so if com1 connect to that pipe, it
      # means com1 want to connect to the producer of that pipe which is A
      # this a trick to implement a long pipe in Ruby.
      customer = target.producer
      producer = self
      pipe = Pipe.new(producer, customer, target.name)
    elsif target.is_a?(Component)
      customer = target
      producer = self
      pipe = Pipe.new(producer, customer)
    elsif target.is_a?(Connectable)
      # target is the agent(means the actually code to run), so we have to
      # wrap it up to make it be scheduled
      customer = Component.new(target)
      producer = self
      pipe = Pipe.new(producer, customer)
    else
      raise "Wrong connection with unexpect type of: #{target.class}"
    end
    customer.add_read_pipe(pipe)
    producer.add_write_pipe(pipe)
    pipe
  end

  def run
    # FIXME: take a sample may not be a good schedule algorithm
    read_pipe = ready_read_pipes.sample
    write_pipe = @write_pipes[read_pipe.name]
    result = @agent.call(read_pipe.gets)
    write_pipe.puts(result) if write_pipe && !result.is_a?(SkipClass)
    result
  end

  def broadcast(value)
    @write_pipes.each_value {|p| p.puts(value)}
  end

  # ready?, blocked? and dead? should be refactored

  def ready?
    if @read_pipes.empty?
      @agent.ready?
    else
      @agent.ready? && !ready_read_pipes.empty?
    end
  end

  def blocked?
    if @read_pipes.emtpy?
      @agent.blocked?
    else
      @agent.blocked? && ready_read_pipes.empty?
    end
  end

  # if @agent is dead, the component must be dead, and should be
  # moved out from the schedule.
  # if @agent wait for some input but there's no such read pipe
  # that avaliavle, then it gose dead.
  def dead?
    @agent.dead? ||
      (@agent.require_argument && avaliable_read_pipes.empty?)
  end

  def ready_read_pipes
    @read_pipes.each_value.select {|p| p.ready?}
  end

  def avaliable_read_pipes
    @read_pipes.each_value.reject {|p| p.dead?}
  end

  def add_read_pipe(pipe)
    @read_pipes[pipe.name] = pipe
  end

  def add_write_pipe(pipe)
    @write_pipes[pipe.name] = pipe
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

end