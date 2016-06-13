# Namespace
module RbStreem
  class StreemIO < Component
    def initialize
      @read_pipes = {}
      @write_pipes = {}
      add_to_task_queue(self)
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

    # In streem.rb level, IO is always ready
    # But in Ruby level, IO may not be ready, noticed!
    def ready?
      true
    end

    def dead?
      false
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
      read_pipes.each_value.all? {|p| p.broken?}
    end

  end
end

# Noticed!
# Override Ruby's default STDIN and STDOUT
STDIN = RbStreem::StreemIn.new($stdin)
STDOUT = RbStreem::StreemOut.new($stdout)

def STDIN.run
  ret = @source.gets
  broadcast(ret)
  ret
end

def STDOUT.run
  ret = ready_read_pipes.sample.gets
  @target.puts(ret)
  ret
end
