require 'colored'

module RbStreem::StreemHelper

  def make_agent(method)
    -> obj { obj.send(method) }
  end

  def chomps
    Component make_agent(:chomp)
  end

  def wait(sec = 1)
   Component -> val { sleep(sec) && val }
  end

  Colored::COLORS.each_key do |color|
    define_method(color) do
      Component make_agent(color)
    end
  end

  def emit(*args)
    args.each {|e| yield e}
  end

  def skip
    RbStreem::SkipClass.instance
  end

  def stringfy
    Component make_agent(:to_s)
  end
  alias_method :to_string, :stringfy

  def integerize
    Component make_agent(:to_i)
  end
  alias_method :to_integer, :integerize

  def seq(*arg)
    ProducerComponent RbStreem::Sequence.new(*arg)
  end

  def Component(agent)
    RbStreem::Component.new(agent)
  end

  def ProducerComponent(agent)
    RbStreem::ProducerComponent.new(agent)
  end

  def def_combinator(name, &blk)
    if blk.nil?
      fail("def combinator must provide a block.")
    end

    define_method name do
      Component(blk.to_proc)
    end
  end

  def strm_arg
    ARGV[1..-1]
  end


  def line_io(filename)
    RbStreem::StreemIn.new(filename)
  end

  def require_strm(strm_file)
    require strm_file
  end

end

module Kernel
  include RbStreem::StreemHelper
end