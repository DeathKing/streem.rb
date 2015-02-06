module RbStreem
  class ProducerComponent < Component

    def run
      result = @agent.call(nil)
      broadcast(result)
      result
    end

  end
end