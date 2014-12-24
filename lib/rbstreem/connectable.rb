# Interface
module Connectable

  @@flows = []

  def |(target)
    if target.is_a?(Pipe)
    elsif target.is_a?(Connectable)
      Pipe.new(self, target)
    else
    end
  end

  %w{blocked? dead? ready? running?}.each do |method|
    define_method(method) do
      raise RuntimeError, "Not implement yet."
    end
  end

  # customer's trigger method will be called with the
  # producer out comes
  def trigger(value)
  end

  def yield(value)
    customers.each do |c|
      c.trigger(value)
    end
    value
  end

end
