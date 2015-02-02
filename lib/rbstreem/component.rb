class RbStreem::Component

  include Connectable

  # This is schedule queue
  @@tasks = []

  attr_reader :read_pipes
  attr_reader :write_pipes

  def self.build(obj)
    if obj.is_a?(Component) then self
    elsif obj.is_a?(Pipe)   then obj.customer
    else Component.new(obj)
    end
  end

  def initialize(agent)
    BasicComponent.new(agent)
  end

end
