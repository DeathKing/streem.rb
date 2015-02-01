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

    def call
      shift!
    end

    def is_producer?
      true
    end

    def is_customer?
      false
    end
    
  end
end

require_relative 'stream/sequence.rb'