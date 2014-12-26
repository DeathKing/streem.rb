# Interface
module Connectable

  def |(target)
    if target.is_a?(Pipe)
    elsif target.is_a?(Connectable)
      Pipe.new(self, target)
    else
    end
  end

end
