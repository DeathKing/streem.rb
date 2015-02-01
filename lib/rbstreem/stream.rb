module RbStreem
  class Stream

    def initialize
      @value = nil
    end

    def shift!
      return Fail.new("Stream already end.") if dead?
      result = @value
      transform_to_next
      result
    end

    def require_argument
    end

    def call
      shift!
    end

  end

  class Sequence < Stream
    def initialize(to, start=0, step=1)
      @to = to
      @step = step
      @value = start
    end

    def ready?
      !dead?
    end

    def require_arugment
      false
    end

    def dead?
      end_of_sequence?
    end

    def end_of_sequence?
      op = [:==, :>, :<]
      @value.send(op[@step <=> 0], @to)
    end

    def transform_to_next
      @value += @step
    end
  end
end
