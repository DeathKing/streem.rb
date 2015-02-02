# Interface
module RbStreem::Connectable

  def |(target)

    pipe = Pipe.new(self, target)


    if target.is_a?(Pipe)
      customer = target.producer
      producer = Component.new(self)
      pipe = Pipe.new(producer, customer, target.name)
    elsif target.is_a?(Component)
      customer = target
      producer = Component.new(self)
      pipe = Pipe.new(producer, customer)
    elsif target.is_a?(Connectable)
      customer = Component.new(target)
      producer = Component.new(self)
      pipe = Pipe.new(producer, customer)
    else
      raise "Wrong connection with unexpect type of: #{target.class}"
    end
    customer.add_read_pipe(pipe)
    producer.add_write_pipe(pipe)
    pipe
  end

end
