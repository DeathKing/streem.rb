# Interface
module RbStreem
  module Connectable
    def |(other)
      if [self, other].all? {|obj| obj.is_a? Connection}
        fail('Connection cannot connect to each other directly')
      end

      target = other.connection_target
      source = self.connection_source

      tag = if other.is_a? Connection
              other.pipe_flow_tag
            elsif self.is_a? Connection
              self.pipe_flow_tag
            else
              Connection.generate_flow_tag
            end

      pipe = Pipe.new(source, target, tag)
      Connection.new(source, target, pipe)
    end
  end
end
