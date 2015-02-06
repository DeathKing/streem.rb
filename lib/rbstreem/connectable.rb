# Interface
module RbStreem::Connectable
  def |(other)
    RbStreem::Pipe.new(self, other)
  end
end
