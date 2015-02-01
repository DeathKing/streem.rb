# Namespace
class StreemIO < Component

  def initialize
    @read_pipes = {}
    @write_pipes = {}
    @@tasks << self
  end

  def run
  end
end

class StreemIn < StreemIO
  
  def initialize(source)
    super()
    @source = source
  end

  def run
    @source.gets
  end

  # IO always ready
  def ready?
    true
  end

  # In IO indeed blocked, but not in streem.rb level, that means
  # 
  def blocked?
    #
  end

  def dead?
    @source.eof?
  end
end

class StreemOut < StreemIO
  def initialize(target)
    super()
    @target = target
  end

  def ready?
    !ready_read_pipes.empty?
  end

  def blocked?
    false
  end

  def dead?
    false
  end

end

# Noticed!
# Override Ruby's default STDIN and STDOUT
STDIN = StreemIn.new($stdin)
STDOUT = StreemOut.new($stdout)

def STDIN.run
  puts "STDIN |-> ".blue
  ret = @source.gets
  broadcast(ret)
  ret
end

def STDOUT.run
  puts "STDOUT |-> ".blue
  ret = ready_read_pipes.sample.gets
  @target.puts(ret)
  ret
end
