class RbStreem::Component

  include Connectable

  # This is schedule queue
  @@tasks = []

  attr_reader :read_pipes
  attr_reader :write_pipes

  def self.build(obj)
    case obj.class
    when Component
      self
    when Pipe
      obj.customer
    else
      component.new(obj)
    end
  end

  def initialize(agent)
    BasicComponent.new(agent)
  end

end