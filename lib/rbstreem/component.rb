class Component

  def initialize(agent)
    raise "Agent must respond to call() method" unless agent.respond_to? :call
    @state = :new
    @agent = agent
    @read_pipes = {}
    @write_pipes = {}
  end

  def run
    @state = :running
    read_pipe = ready_read_pipe.sample
    # This is not a good schedule algorithm for practise,
    # but all in all, this is a conception.
    out_pipe = @write_pipes[read_pipe.name]
    ret = @agent.call(read_pipe.gets)
    out_pipe.puts(ret) if out_pipe
    # before switch out, determined state
    @state = ready? ? :ready : :blocked
  end

  def running?
    @state == :running
  end

  def ready?
    @state == :ready
  end

  def ready_read_pipes
    @read_pipes.select {|p| p.ready?}
  end

  def add_read_pipe(pipe)
    @read_pipes[pipe.name] = pipe
  end

  def add_write_pipe(pipe)
    @write_pipes[pipe.name] = pipe
  end

  def trigger
    @state = :ready unless running?
  end

end