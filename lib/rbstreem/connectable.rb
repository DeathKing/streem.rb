# Interface
module RbStreem::Connectable
  def |(other)
    target = other.connection_target
    source = self.connection_source
    pipe = RbStreem::Pipe.new(source, target)
    RbStreem::Connection.new(source, target, pipe)
  end
end
