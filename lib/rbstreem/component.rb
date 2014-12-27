class Component

  @@tasks = []

  def initialize(agent)
    raise "Agent must respond to call() method" unless agent.respond_to? :call
    @agent = agent
    @read_pipes = {}
    @write_pipes = {}
    @@tasks << self
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

  def dead?
    @agent.dead? || avaliable_read_pipes.empty?
  end

  def ready_read_pipes
    @read_pipes.select {|p| p.ready?}
  end

  def avaliable_read_pipes
    @read_pipes.reject {|p| p.dead?}
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