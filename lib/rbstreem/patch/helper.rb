require 'colored'

module Kernel

  def make_agent(method)
    -> obj { obj.send(method) }
  end

  def chomps
    make_agent(:chomp)
  end

  def wait(sec = 1)
    -> val { sleep(sec) && val }
  end

  Colored::COLORS.each_key do |color|
    define_method(color) do
      make_agent(color)
    end
  end

  SKIP_INSTANCE = RbStreem::SkipClass.new

  def skip
    SKIP_INSTANCE
  end

  def seq(*arg)
    ProducerComponent(RbStreem::Sequence.new(*arg))
  end

  def Component(agent)
    RbStreem::Component.new(agent)
  end

  def ProducerComponent(agent)
    RbStreem::ProducerComponent.new(agent)
  end

end