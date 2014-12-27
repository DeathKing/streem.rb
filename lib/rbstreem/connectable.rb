# Interface
module Connectable

  def |(target)
    if target.is_a?(Pipe)
      customer = target.producer
      producer = Component.new(self)
      pipe = Pipe.new(customer, producer, pipe.name)
    elsif target.is_a?(Connectable)
      customer = Component.new(target)
      producer = Component.new(self)
      pipe = Pipe.new(customer, producer)
    else
      raise "Wrong connection with unexpect type of: #{target.class}"
    end
    customer.add_read_pipe(pipe)
    producer.add_write_pipe(pipe)
    pipe
  end

end
