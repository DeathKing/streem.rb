# Namespace
module RbStreem
  class StreemIO < Component
    def initialize
      @read_pipes = {}
      @write_pipes = {}
      @@tasks << self
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
      @source.eof?
    end
  end

  class StreemOut < StreemIO
    def initialize(target)
      super()
      @target = target
    end

    def ready?
      true
    end

    def blocked?
      false
    end

    def dead?
      false
    end

  end
end

# Noticed!
# Override Ruby's default STDIN and STDOUT
STDIN = StreemIn.new($stdin)
STDOUT = StreemOut.new($stdout)

def STDIN.run
  ret = @source.gets
  boardcast(ret)
  ret
end

def STDOUT.run
  ret = ready_read_pipes.sample.gets
  @target.puts(ret)
  ret
end
