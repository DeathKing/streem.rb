module RbStreem
  class Sequence < Stream
    def initialize(to, start = 1, step = 1)
      @to, @step, @value = to, step, start
    end

    def ready?
      !dead?
    end

    def dead?
      end_of_sequence?
    end

    def end_of_sequence?
      @value.send([:==, :>, :<][@step <=> 0], @to)
    end

    def transform_to_next
      @value += @step
    end
  end
end
