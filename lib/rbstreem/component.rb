class Component

  include Connectable

  @@tasks = []

  def initialize(agent)
    raise "Agent must respond to call method" unless agent.respond_to? :call
    raise "Agent must respond to dead? method" unless agent.respond_to? :dead?
    @agent = agent
    @read_pipes = {}
    @write_pipes = {}
    @@tasks << self
  end

  def |(target)
    if target.is_a?(Pipe)
      customer = target.producer
      producer = self
      pipe = Pipe.new(customer, producer, pipe.name)
    elsif target.is_a?(Component)
      customer = target
      producer = self
      pipe = Pipe.new(customer, producer)
    elsif target.is_a?(Connectable)
      customer = Component.new(target)
      producer = Component.new(self)
      pipe = Pipe.new(customer, producer)
    else
      raise "Wrong connection with unexpect type of: #{target.class}"
    end
    customer.add_read_pipe(pipe)
    producer.add_write_pipe(pipe)
    pipe
  end

  def run
    # This is not a good schedule algorithm for practise,
    # but all in all, this is a conception.
    read_pipe = ready_read_pipe.sample
    write_pipe = @write_pipes[read_pipe.name]
    ret = @agent.call(read_pipe.gets)
    write_pipe.puts(ret) if write_pipe
    ret
  end

  def boardcast(value)
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