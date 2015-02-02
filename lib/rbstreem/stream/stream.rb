module RbStreem
  class Stream

    def initialize
      @value = nil
    end

    def shift!
      dead? && fail('Stream already end.')
      result = @value
      transform_to_next
      result
    end

    def call
      shift!
    end

    def producer?
      true
    end

    def customer?
      false
    end
    
  end
end
