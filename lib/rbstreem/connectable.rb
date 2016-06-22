# Interface
module RbStreem
  module Connectable
    def |(other)
      check_connection_target_type(other)

      target = other.connection_target
      source = self.connection_source

      flow_tag = if other.is_a? Pipe
                   other.flow_tag
                 elsif self.is_a? Pipe
                   self.flow_tag
                 else
                   Pipe.generate_flow_tag
                 end

      Pipe.new(source, target, flow_tag)
    end

    def check_connection_target_type(target)
      fail("Class which included this class must implemented the check_connection_target_type method.")
    end

    def connection_target
      fail("Class which included this class must implemented the connection_target method.")
    end

    def connection_source
      fail("Class which included this class must implemented the connection_source method.")
    end
  end
end
