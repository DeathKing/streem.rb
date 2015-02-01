require 'colored'

module Kernel

  SKIP_INSTANCE = SkipClass.new

  def skip
    SKIP_INSTANCE
  end

  def seq(*arg)
    Sequence.new(*arg)
  end

  Colored::COLORS.each_key do |color|
    define_method(color) do
      -> str { str.send(color) }
    end
  end

end