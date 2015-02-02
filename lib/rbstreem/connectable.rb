# Interface
module RbStreem::Connectable
  def |(other)
    Pipe.new(self, other)
  end
end
